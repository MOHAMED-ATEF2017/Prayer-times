import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'qiblah/qiblah_compass.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {

  Location location = new Location();

  bool _serviceEnabled;
  GeolocationStatus geolocationStatus;
  Position _currentPosition;
  final _locationStreamController =
  StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  @override
  void initState() {
    super.initState();

    checkPermission();
    _checkLocationStatus();

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


    Navigator.push(context,
        MaterialPageRoute(builder: (context)=>QiblahCompass()));

  }


  void checkPermission() async{


    geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    await Geolocator().checkGeolocationPermissionStatus();
    _serviceEnabled = await location.serviceEnabled();
    print("${_serviceEnabled}1");
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      print("${_serviceEnabled}2");
      if(_serviceEnabled){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>QiblahCompass()));
      }
      if (!_serviceEnabled) {
        return;
      }
    }
    print("--------------------------------------");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}