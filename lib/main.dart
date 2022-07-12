import 'package:cvparser_b21_01/bindings/initial_page_binding.dart';
import 'package:cvparser_b21_01/bindings/main_page_binding.dart';
import 'package:cvparser_b21_01/bindings/notifications_overlay_binding.dart';
import 'package:cvparser_b21_01/bindings/services_binding.dart';
import 'package:cvparser_b21_01/views/initial_page.dart';
import 'package:cvparser_b21_01/views/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/services.dart' as flutter_services;

import 'colors.dart' as my_colors;
import 'services/i_extract.dart';
import 'views/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  flutter_services.SystemChrome.setPreferredOrientations([
    flutter_services.DeviceOrientation.landscapeLeft,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CVParserApp());
}

class CVParserApp extends StatelessWidget {
  const CVParserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainButtonTheme = ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          my_colors.colorSecondaryLightGreenPlant,
        ),
      ),
    );

    final mainTheme = ThemeData(
      colorScheme: my_colors.colorScheme,
      elevatedButtonTheme: mainButtonTheme,
      fontFamily: "Merriweather",
    );

    return GetMaterialApp(
      title: "CV Parser",
      theme: mainTheme,
      initialBinding: BindingsBuilder(
        () {
          ServicesBinding().dependencies();
          NotificationsOverlayBinding().dependencies();
        },
      ),
      onGenerateRoute: (settings) {
        final cvParser = Get.find<IExtract>();

        var uri = Uri.parse(settings.name ?? "");

        // setup correct api parameter
        switch (uri.queryParameters['api']) {
          case 'mock':
            cvParser.mock = true;
            break;
          case 'iExtract':
            cvParser.mock = false;
            break;
          default:
            // save all the parameters and add api=mock
            cvParser.mock = true;
            final newParams = <String, String>{};
            newParams.addAll(uri.queryParameters);
            newParams['api'] = 'mock';
            uri = uri.replace(queryParameters: newParams);
            break;
        }

        // update global parameters handler
        Get.parameters = uri.queryParameters;

        // route
        if (uri.path == "/main" && settings.arguments != null) {
          return GetPageRoute(
            settings: settings.copyWith(name: uri.toString()),
            page: () => const MainPage(),
            binding: MainPageBinding(),
          );
        } else {
          uri = uri.replace(path: "/initial");
          return GetPageRoute(
            settings: settings.copyWith(name: uri.toString()),
            page: () => const InitialPage(),
            binding: InitialPageBinding(),
          );
        }
      },
      builder: (context, content) {
        return ApplicationRoot(child: content!);
      },
    );
  }
}
