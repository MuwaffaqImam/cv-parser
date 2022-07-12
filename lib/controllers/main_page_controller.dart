import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cvparser_b21_01/controllers/notifications_overlay_controller.dart';
import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:cvparser_b21_01/datatypes/misc/indexable.dart';
import 'package:cvparser_b21_01/datatypes/report.dart';
import 'package:cvparser_b21_01/services/file_saver.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:cvparser_b21_01/services/reports.dart';
import 'package:cvparser_b21_01/views/dialogs/fail_dialog.dart';
import 'package:cvparser_b21_01/views/dialogs/progress_dialog.dart';
import 'package:cvparser_b21_01/services/search.dart';
import 'package:cvparser_b21_01/views/dialogs/report_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

// TODO: refactor (separate services, rearrange datatypes (especially cv's))

class MainPageController extends GetxController {
  final keyLookup = Get.find<KeyListener>();
  final fileSaver = Get.find<FileSaver>();
  final reporter = Get.find<Reports>();

  late final Future<void> dummyWorker;
  late final Future<void> garbageCollector; // removes failed to parse cv's

  // List<NotParsedCV> filteredCVs = [];
  String searchQuerry = "";
  RegExp contentAreaQuery = RegExp("");

  /// Using lazy approach, we will initially upload cv's as [NotParsedCV],
  /// but on the first invocation it converts them to the [ParsedCV].

  /// As we have async methods, we need to prevent undefined behaviour
  /// when two coroutines modify the same data.
  /// For this, we will block methods invocation with [_busy] flag
  /// untill the occupator future is done.
  ///
  /// Note: there can be only one sync/async worker that
  /// is working with the data inside this class
  bool _busy = false;

  /// Important: before modifying this data, firstly check the [_busy] flag,
  /// also it's supposed to be any kind modified only inside this file,
  /// any outer invocation must just read data
  final cvs = <Selectable<NotParsedCV>>[].obs;

  /// the content to be displayed on the left
  final _current = Rxn<ParsedCV>();

  /// used for range select
  int? selectPoint;

  /// subscribe to the stream of key events
  late StreamSubscription<dynamic> _escListener;
  late StreamSubscription<dynamic> _delListener;

  /// needed for workers
  bool closed = false;

  /// get current applying search filter to it
  ParsedCV? get current {
    ParsedCV? res = _current.value;

    // pass unfiltered
    if (res == null) {
      return res;
    }

    // filter
    CVEntries filteredEntries = {};

    for (final entry in res.data.entries) {
      String label = entry.key;
      final filteredMatches = <CVMatch>[];
      for (final cvmatch in entry.value) {
        String match = cvmatch.match;
        String sentence = cvmatch.sentence;

        String combine = """
          label: $label
          match: $match
          sentence: $sentence
        """;

        if (contentAreaQuery.hasMatch(combine)) {
          filteredMatches.add(cvmatch);
        }
      }

      if (filteredMatches.isNotEmpty) {
        filteredEntries[label] = filteredMatches;
      }
    }

    return ParsedCV(
      filename: res.filename,
      data: filteredEntries,
    );
  }

  /// may be used by view to filter what it need to display
  List<Indexable<Selectable<NotParsedCV>>> get filteredCvs {
    final res = <Indexable<Selectable<NotParsedCV>>>[];
    int index = 0;
    var tmp =
        CVsFilter(cvs.map((element) => element.item).toList(), searchQuerry);
    var filtered = tmp.getFiltered();
    for (final packet in cvs) {
      final cv = packet.item;
      if (filtered.contains(cv)) {
        res.add(
          Indexable(
            item: packet,
            index: index,
          ),
        );
      } else {
        // whenever files become displayed, it deselects undisplayed ones
        packet.isSelected = false;
      }
      index++;
    }
    return res;
  }

  /// Creates native dialog for user to select files
  void askUserToUploadPdfFiles() {
    _asyncSafe(
      "File uploader",
      () async* {
        yield ProgressDone(null, "waiting for user");

        FilePickerResult? picked = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["pdf"], // TESTIT: what if not pdf
          allowMultiple: true,
          withReadStream: true,
          withData: false,
          lockParentWindow: true,
        );

        // if cvs is not blocked and there is some input
        if (picked != null) {
          final len = picked.files.length;
          var done = 0;

          for (PlatformFile file in picked.files) {
            // add an NotParsedCV
            cvs.add(
              Selectable(
                item: RawPdfCV(
                  // just because it's web, we cannot store file path,
                  // but we can get stream of filedata
                  filename: file.name,
                  readStream: file.readStream!,
                  size: file.size,
                ),
                isSelected: false,
              ),
            );

            done++;
            yield ProgressDone(
              done / len,
              "$done / $len",
            );
          }
        }
      },
    );
  }

  /// Tries to delete selected
  void deleteSelected() {
    _syncSafe(
      () {
        var remaining = <Selectable<NotParsedCV>>[];
        for (var cv in cvs) {
          if (!cv.isSelected) {
            remaining.add(cv);
          }
        }
        cvs.value = remaining;
        selectPoint = null;
      },
    );
  }

  /// Tries to deselect all
  void deselectAll() {
    _syncSafe(
      () {
        for (var cv in cvs) {
          cv.isSelected = false;
        }
        cvs.refresh();
      },
    );
  }

  void exportCurrent() {
    _asyncSafe(
      "Exporting",
      () async* {
        // export to json string
        const encoder = JsonEncoder.withIndent("  ");
        String encoded = encoder.convert(current);

        // save to file
        await fileSaver.saveJsonFile(
          name: "single.json",
          bytes: Uint8List.fromList(encoded.codeUnits),
        );
      },
    );
  }

  /// Try to export selected
  void exportSelected() {
    _asyncSafe(
      "Exporting",
      () async* {
        final parsedCVs = <ParsedCV>[];
        final selected = <NotParsedCV>[];

        // synchronously collect all that we need to process
        // to make sure that while we parsing a cv
        // no one can change the list that we were working on
        for (final cv in cvs) {
          if (cv.isSelected) {
            selected.add(cv.item);
          }
        }

        // process
        for (var index = 0; index != selected.length; index++) {
          // iterate
          var cv = selected[index];

          // notify that we are parsing something
          yield ProgressDone(
            (index + 1) / selected.length,
            "${index + 1} / ${selected.length} \n ${cv.filename}",
          );

          // make sure that all cv's are parsed
          try {
            parsedCVs.add(await _parsedCv(cv));
          } catch (e) {
            // no need to add cv's that cannot be parsed
          }
        }

        // notify that we are parsing something
        yield ProgressDone(
          null,
          "saving as a file...",
        );

        // export to json file and save it
        {
          // export to json string
          const encoder = JsonEncoder.withIndent("  ");
          String encoded = encoder.convert(parsedCVs);

          // save to file
          await fileSaver.saveJsonFile(
            name: "bunch.json",
            bytes: Uint8List.fromList(encoded.codeUnits),
          );
        }
      },
    );
  }

  /// Inverts selection
  void invertSelection() {
    _syncSafe(
      () {
        for (final cv in cvs) {
          cv.isSelected = !cv.isSelected;
        }
        cvs.refresh();
        // then filteredCvs will deselect undisplayed ones
      },
    );
  }

  @override
  void onClose() async {
    await _escListener.cancel();
    await _delListener.cancel();
    closed = true;

    // ya, it's ofcource better to track the actual future instances instead of
    // just flag [_busy], and cancel them when the actual class instance becomes
    // destroyed, but it's muuuch complex, moreover the class instance is
    // supposed to be destroyed on the application exit, so all of them would be
    // forced to end up with him

    super.onClose();
  }

  @override
  void onInit() {
    // setup keyboard listeners
    _escListener = keyLookup.escEventStream.listen((event) {
      if (event == KeyEventType.down) {
        deselectAll();
      }
    });
    _delListener = keyLookup.delEventStream.listen((event) {
      if (event == KeyEventType.down) {
        deleteSelected();
      }
    });

    // prepare for workers
    closed = false;

    // setup a dummy worker
    dummyWorker = Future(() async {
      int index = 0;
      while (!closed) {
        // iterate and parse CV's
        // also it stops parsing if the _busy is set,
        // but if a work was already started, it will be done even with _busy
        if (cvs.isNotEmpty && !_busy) {
          index %= cvs.length;
          if (!cvs[index].item.isParseCached()) {
            try {
              await _parsedCv(cvs[index].item);
              if (closed) {
                return;
              }
            } catch (e) {
              // so the item will be removed by the garbageCollector
            }
            index = 0;
          } else {
            index++;
          }
        } else {
          index = 0;
        }

        // delay not to overload system
        await Future.delayed(const Duration(milliseconds: 16));
      }
    });

    // remove failed cv's
    garbageCollector = Future(() async {
      int index = 0;
      while (!closed) {
        if (cvs.isNotEmpty) {
          index %= cvs.length;
          final cv = cvs[index].item;
          if (cv.isParseCachedFailed()) {
            // Note: it is not async safe, so the methods like export selected
            // must first synchronously take it's own list of items
            // and only then operate on it
            cvs.removeAt(index);
            Get.find<NotificationsOverlayController>().notify(
              "File \"${cv.filename}\" was removed because it cannot be parsed",
            );
            index = 0;
          } else {
            index++;
          }
        } else {
          index = 0;
        }

        // delay not to overload system
        await Future.delayed(const Duration(milliseconds: 16));
      }
    });

    // retrive data from route
    if (Get.arguments != null) {
      for (NotParsedCV cv in Get.arguments) {
        cvs.add(
          Selectable(
            item: cv,
            isSelected: false,
          ),
        );
      }
    }

    // schedule it to the next frame when the view will be built
    Future(() {
      setCurrent(0);
    });

    super.onInit();
  }

  /// Switches select of cv
  void select(int index) {
    _syncSafe(
      () {
        cvs[index].isSelected = true;
        cvs.refresh();
      },
    );
  }

  /// Select all that matches query
  void selectAll() {
    _syncSafe(
      () {
        for (final cv in cvs) {
          var tmp = CVsFilter(
                  cvs.map((element) => element.item).toList(), searchQuerry)
              .getFiltered();

          cv.isSelected = tmp.contains(cv.item);
        }
        cvs.refresh();
        // then filteredCvs will deselect undisplayed ones
      },
    );
  }

  /// Select parsed that matches query
  void selectParsed() {
    _syncSafe(
      () {
        for (final cv in cvs) {
          var tmp = CVsFilter(
                  cvs.map((element) => element.item).toList(), searchQuerry)
              .getFiltered();
          cv.isSelected =
              cv.item.isParseCachedComplete() && tmp.contains(cv.item);
        }
        cvs.refresh();
        // then filteredCvs will deselect undisplayed ones
      },
    );
  }

  /// Tries to parse this CV and then set the [current]
  void setCurrent(int index) {
    _asyncSafe(
      "Parsing results",
      () async* {
        _current.value = await _parsedCv(cvs[index].item);
      },
    );
  }

  /// Switches select of cv
  void switchSelect(int index) {
    _syncSafe(
      () {
        cvs[index].isSelected = !cvs[index].isSelected;
        cvs.refresh();
      },
    );
  }

  /// apply new search filter
  void updateFileExplorerQuery(String text) {
    try {
      searchQuerry = text;
    } catch (e) {
      searchQuerry = "";
    }
    cvs.refresh();
  }

  /// show dialog with
  void makeReport(CVMatch context, String label) {
    if (_busy) {
      return;
    }
    _busy = true;

    Get.dialog(
      ReportDialog(
        onTextSubmitted: (reason) {
          _busy = false;
          Get.back();

          _asyncSafe(
            "Uploading report...",
            () async* {
              yield ProgressDone(null, "in process");

              await reporter.makeReport(
                Report.fromCVMatch(
                  label: label,
                  reason: reason,
                  cvmatch: context,
                ),
              );

              // update check button
              // _current
              // _current.refresh();
            },
          );
        },
      ),
      barrierDismissible: false, // make it blocking
    );
  }

  /// Wrapper method to make it safe, see [_busy]
  /// it also handles crushes of coroutines
  /// and is responsible for blocking dialog popup
  void _asyncSafe(
    String dialogTitle,
    Stream<ProgressDone> Function() coroutine,
  ) {
    // TODO: cancellable
    if (_busy) {
      return;
    }
    _busy = true;
    final safeProgressStream = StreamController<ProgressDone>();

    Get.dialog(
      ProgressDialog(
        titleText: dialogTitle,
        progressStream: safeProgressStream.stream,
      ),
      barrierDismissible: false, // make it blocking
    );

    finalize() {
      _busy = false;
      Get.back();
      safeProgressStream.close();
    }

    safeProgressStream.add(ProgressDone(0, "please wait..."));
    coroutine().listen(
      safeProgressStream.add,
      onDone: () {
        safeProgressStream.add(ProgressDone(1, "done!"));
        finalize();
      },
      onError: (e) {
        finalize();
        Get.dialog(
          FailDialog(
            titleText: "Action failed",
            details: e.toString(),
          ),
        );
      },
      cancelOnError: true,
    );
  }

  /// This is a wrapper of item.parse(),
  /// so it will notify UI to redraw if some changes has happened
  Future<ParsedCV> _parsedCv(NotParsedCV cv) async {
    bool wasNotCached = !cv.isParseCached();
    final res = await cv.parse();
    // here cvs[index].item will be in state cache completed
    if (wasNotCached) {
      cvs.refresh();
    }
    return res;
  }

  void _syncSafe(
    void Function() func,
  ) {
    if (_busy) {
      return;
    } // no need to mark _busy because this is a synchronus function

    try {
      func();
    } catch (e) {
      Get.dialog(
        FailDialog(
          titleText: "Action failed",
          details: e.toString(),
        ),
      );
    }
  }
}
