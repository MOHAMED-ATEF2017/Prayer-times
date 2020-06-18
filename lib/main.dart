import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_qiblah_example/pyayer/Prayer_Time_Setting.dart';
import 'package:flutter_qiblah_example/pyayer/prayer_time.dart';
import 'package:flutter_qiblah_example/qiblah/loading_indicator.dart';
import 'package:provider/provider.dart';

import 'provider/prayer_times.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PrayerTimes(),
        ),
      ],
      child: MaterialApp(
        home: FutureBuilder(
          future: _deviceSupport,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return LoadingIndicator();
            if (snapshot.hasError)
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );

            if (snapshot.data) return PrayerTime();

            return null;
          },
        ),
        title: 'القبلة',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ar', 'SA'),
        ],
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primaryColor: Color.fromRGBO(78, 161, 181, 1),
          accentColor: Color.fromRGBO(78, 161, 181, 1),
          brightness: Brightness.light,
        ),
        initialRoute: PrayerTime.id,
        routes: {
          PrayerTimeSetting.id: (BuildContext context) =>
          new PrayerTimeSetting(),
          PrayerTime.id: (BuildContext context) => new PrayerTime(),
        },

/*
        supportedLocales: [
          const Locale('ar'),
        ],
        locale: Locale('ar'),
        // These delegates make sure that the localization data for the proper language is loaded
        localizationsDelegates: [
          // THIS CLASS WILL BE ADDED LATER
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
*/
      ),
    );
  }
}