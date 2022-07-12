import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class KeyListener extends GetxService {
  var ctrl = false;
  var shift = false;

  // NOTE: i'm too lazy to fulfill this thing,
  // as now it's enough of this functionality
  final _escEventStream = StreamController<KeyEventType>.broadcast();
  final _delEventStream = StreamController<KeyEventType>.broadcast();

  KeyListener() {
    window.onKeyData = (final keyData) {
      if (keyData.type != KeyEventType.repeat) {
        if (keyData.logical == LogicalKeyboardKey.escape.keyId) {
          _escEventStream.add(keyData.type);
        } else if (keyData.logical == LogicalKeyboardKey.delete.keyId) {
          _delEventStream.add(keyData.type);
        } else if (keyData.logical == LogicalKeyboardKey.controlLeft.keyId ||
            keyData.logical == LogicalKeyboardKey.controlRight.keyId) {
          ctrl = keyData.type == KeyEventType.down;
        } else if (keyData.logical == LogicalKeyboardKey.shiftLeft.keyId ||
            keyData.logical == LogicalKeyboardKey.shiftRight.keyId) {
          shift = keyData.type == KeyEventType.down;
        }
      }

      // Let event pass to other focuses if it is not the key we looking for
      return false;
    };
  }
  Stream<KeyEventType> get delEventStream => _delEventStream.stream;

  Stream<KeyEventType> get escEventStream => _escEventStream.stream;

  @override
  void onClose() {
    _escEventStream.close();
    _delEventStream.close();
  }
}
