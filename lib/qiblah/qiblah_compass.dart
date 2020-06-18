import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_qiblah_example/pyayer/Prayer_Time_Setting.dart';
import 'package:flutter_qiblah_example/pyayer/prayer_time.dart';
import 'package:flutter_qiblah_example/qiblah/loading_indicator.dart';
import 'package:flutter_qiblah_example/qiblah/location_error_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibration/vibration.dart';

class QiblahCompass extends StatefulWidget {
  @override
  _QiblahCompassState createState() => _QiblahCompassState();
}

Position _currentPosition;
String _currentAddress;
Color textColor = Colors.black;

Color appColor = Color.fromARGB(1, 78, 161, 181);

class _QiblahCompassState extends State<QiblahCompass>
    with SingleTickerProviderStateMixin {
  final _locationStreamController =
  StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    Timer.run(()=>_alert(context));
    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    _checkLocationStatus();
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _alert(BuildContext context) {
    return showDialog<void>(
      context:  context,
      builder: (context)  {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'قم بتدوير هاتفك لتحسين دقة البوصلة بالحركة التالية',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Sukar',
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ),
              Image.asset("assets/set_compass.png")
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        );
      },
    );
  }

  Future<void> _alertLocation(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.8),
          child: AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  child: Image.asset(
                    'assets/cancel.png',
                    width: 15,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                Text(
                  'تم تحديث موقعك الحالي',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Sukar',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E824C)),
                ),
                Image.asset(
                  'assets/success.png',
                  width: 20,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
          ),
        );
      },
    );
  }

  _vibration() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'القبلة',
            style: TextStyle(
              fontFamily: 'Sukar',
              fontWeight: FontWeight.w200,
              color: Color.fromRGBO(78, 161, 181, 1),
            ),
          ),
          backgroundColor: Color.fromRGBO(251, 252, 252, 1),
          centerTitle: true,
//          leading: IconButton(
//              icon: Icon(
//                Icons.settings,
//                color: Color.fromRGBO(78, 161, 181, 1),
//              ),
//              onPressed: () => Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => PrayerTime()))),
          actions: <Widget>[
            IconButton(
                icon: Image.asset('assets/compassIcon.png'),
                onPressed: () => _alert(context)),
          ],
        ),

        body: Container(
          child: StreamBuilder(
            stream: stream,
            builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('loader 1');
                return LoadingIndicator();
              }

              if (snapshot.data.enabled == true) {
                switch (snapshot.data.status) {
                  case GeolocationStatus.granted:
                    return StreamBuilder(
                      stream: FlutterQiblah.qiblahStream,
                      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          print('loader 2');
                          return LoadingIndicator();
                        }

                        final qiblahDirection = snapshot.data;
//        print(((qiblahDirection.qiblah ?? 0) * (pi / 180) * -1));

                        if (qiblahDirection.direction.round() ==
                            qiblahDirection.offset.round()) {
                          _vibration();
                          textColor = Colors.green;
                          controller.forward().then((_) {
                            Duration(seconds: 2);
                            controller.reverse();
                          });
                        } else {
                          textColor = Colors.black;
                        }

                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                  top: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height:
                                          MediaQuery.of(context).size.height *
                                              .04,
                                        ),

                                        Text(
                                          "القبلة",
                                          style: TextStyle(
                                              fontFamily: 'Sukar',
                                              fontWeight: FontWeight.w200,
                                              fontSize: 25),
                                        ),
                                        Text(
                                          "${qiblahDirection.direction.toStringAsFixed(0)}°",
                                          style: TextStyle(
                                              color: textColor,
                                              fontFamily: 'Sukar',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 50),
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              _currentAddress != null
                                                  ? _currentAddress
                                                  : "",
                                              style: TextStyle(
                                                  fontFamily: 'Sukar',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(Icons.place, size: 15,),
                                          ],
                                        )
                                        //  Text(position.),
                                      ],
                                    ),
                                  )),
                              Transform.scale(
                                scale: controller.value * .88,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF00ff33).withOpacity(.2),
                                      border: Border.all(
                                          width: 5, color: Colors.green)),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .8,
                                child: Transform.rotate(
                                  angle: ((qiblahDirection.direction ?? 0) *
                                      (pi / 180) *
                                      -1),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/compass.png'),
                                      Image.asset('assets/iconfinder.png')
                                    ],
                                  ),
                                ),
                                // width: MediaQuery.of(context).size.width*0.7,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .7,
                                child: Transform.rotate(
                                  angle: ((qiblahDirection.qiblah ?? 0) *
                                      (pi / 180) *
                                      -1),
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset(
                                          (qiblahDirection.direction.round() ==
                                              qiblahDirection.offset.round())
                                              ? 'assets/kaaba1.png'
                                              : 'assets/kabah.png',
                                          fit: BoxFit.contain,
                                          height:
                                          MediaQuery.of(context).size.width *
                                              .15,
                                          alignment: Alignment.center,
                                        ),

                                        SizedBox(
                                          height:
                                          MediaQuery.of(context).size.width *
                                              .085,
                                        ),
                                        //
                                        Image.asset(
                                          'assets/Group.png',
                                          fit: BoxFit.contain,
                                          height:
                                          MediaQuery.of(context).size.width *
                                              .5,
                                          alignment: Alignment.center,
                                        ),
                                        SizedBox(
                                          height:
                                          MediaQuery.of(context).size.width *
                                              .185,
                                        ),
                                      ],
                                    ),
                                    //   width: MediaQuery.of(context).size.width,
                                    // height: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 1,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset('assets/mosque.png',
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fitHeight
                                    // height: 200,
                                    //  alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );

                  case GeolocationStatus.denied:
                    return LocationErrorWidget(
                      error: "Location service permission denied",
                      callback: _checkLocationStatus,
                    );
                  case GeolocationStatus.disabled:
                    return LocationErrorWidget(
                      error: "Location service disabled",
                      callback: _checkLocationStatus,
                    );
                  case GeolocationStatus.unknown:
                    return LocationErrorWidget(
                      error: "Unknown Location service error",
                      callback: _checkLocationStatus,
                    );
                  default:
                    return Container();
                }
              } else {
                //setState(() {
                //});
                return LocationErrorWidget(
                  error: "Please enable Location service",
                  callback: _checkLocationStatus,
                );
              }
            },
          ),
        ),
        floatingActionButton: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SizedBox();
            if (snapshot.data.enabled == true) {
              return FloatingActionButton(
                  backgroundColor: Colors.white,
                  //rgba(78, 161, 181, 1) 78, 161, 181
                  child: Icon(
                    Icons.my_location,
                    color: Color.fromRGBO(78, 161, 181, 1),
                  ),
                  onPressed: () => _alertLocation(context));
            } else {
              return SizedBox();
            }
          },
        ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == GeolocationStatus.denied) {
      await FlutterQiblah.requestPermission();

      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else
      _locationStreamController.sink.add(locationStatus);
  }

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    print("dddddddddddddddddddddddddddddddddddd");
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude,
          localeIdentifier: 'ar');

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
    controller.dispose();
  }
}