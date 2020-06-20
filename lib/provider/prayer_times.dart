import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_qiblah_example/helper/http_helper.dart';
import 'package:flutter_qiblah_example/model/Location_Query_Auto_Complete.dart';
import 'package:flutter_qiblah_example/model/location_methods_setting.dart';
import 'package:flutter_qiblah_example/model/player-model.dart';
import 'package:flutter_qiblah_example/model/prayer_setting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrayerTimes with ChangeNotifier {

  bool _waiting = true;
  final http = HttpHelper();
  PrayerModel prayerModel;

  List<LocationAndMethods> locationMethodsList = List<LocationAndMethods>();
  List<LocationQueryAutoComplete> locationQueryAutoCompleteList;




// ----------------------------  Get Value ----------------------------


  bool get waiting {
    return _waiting;
  }

  PrayerModel get prayer{
    return prayerModel;
  }

  List<LocationAndMethods> get locationMethods{
    return locationMethodsList;
  }

// ----------------------  Times ----------------------------

  Future<void> getTimes(double longitude, double latitude , {String lang = "ar"}) async {
    try {
      var response = await http.postJsonData(
          url: '/call/PrayerTimes/timings/',
          data: {
            "lat": 30.5497,
            "lng": 31.2444,
            "lang": "ar",
            "loginuid": "9458b0ad-80fb-4c0f-a515-58159c1f51fb"
          },
          token: null
      );

      print(response);
      print("-----------------------------------");

      prayerModel = PrayerModel.fromJson(response);
      _waiting = false;
      notifyListeners();

    } catch (error) {
      throw error;
    }
  }


//------------------------- method time -----------------
  Future<void> getMethod() async {
    try {
      if(locationMethods.length ==0){
        var response = await http.postJsonData(
            url: '/api3/get/prayer_method_type/',
            data: {
              "lang": "ar",
              "loginuid": "9458b0ad-80fb-4c0f-a515-58159c1f51fb"
            },
            token: null
        );
        print("-----------------------------------");
        print(response['data']);

        List<dynamic> lstMethods = response['data'];

        lstMethods.forEach((item){
          locationMethodsList.add(LocationAndMethods.fromJson(item));
        });
        print("-------------- locationMethodsList.length ----------------");
        print("-------------- ${locationMethodsList.length}----------------");

        print("-----------------------------------");

        // prayerModel = PrayerModel.fromJson(response);
        // _waiting = false;
        notifyListeners();

      }
    } catch (error) {
      throw error;
    }
  }

//------------------------- get setting values -----------------

Future<PrayerSettingModel> getSettingValue ()async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  return PrayerSettingModel.fromJson(prefs.get("prayerSetting"));
  
}


//------------------------- set setting values -----------------

  Future<void> setSettingValue (PrayerSettingModel modelSetting)async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
prefs.setString("prayerSetting", modelSetting.toString());
print("khkhkhkhkhkhkkhkkhkhhk");

modelSetting = prefs.get("prayerSetting");
    print(json.decode(modelSetting.mazhab));

    

  }


}