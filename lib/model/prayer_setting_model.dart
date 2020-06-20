import 'package:flutter_qiblah_example/model/prayer_notification_model.dart';

class PrayerSettingModel {
  String city;
  String calMethod;
  String mazhab;
  String prayerVoice;
  bool backgroundWorking;
  bool typeNotification;
  List<PrayerNotificationModel> listNotSet;

  PrayerSettingModel({
    this.backgroundWorking,
    this.calMethod,
    this.city,
    this.listNotSet,
    this.mazhab,
    this.prayerVoice,
    this.typeNotification,
  });

  Map<String, dynamic> toJson() => _modelToJson(this);
  Map<String, dynamic> _modelToJson(PrayerSettingModel model) {
    return <String, dynamic>{
      'backgroundWorking': model.backgroundWorking,
      'calMethod': model.calMethod,
      'city': model.city,
      'mazhab': model.mazhab,
      'prayerVoice': model.prayerVoice,
      'typeNotification': model.typeNotification,
      'listNotSet': model.listNotSet,
    };
  }

  factory PrayerSettingModel.fromJson(Map<String, dynamic> json) =>
      _modelFromJson(json);
}

PrayerSettingModel _modelFromJson(Map<String, dynamic> json) {
  List<dynamic> list = List<dynamic>();

  List<PrayerNotificationModel> listNot = List<PrayerNotificationModel>();

  list.addAll(json['listNotSet']);

  list.forEach((item) {
    listNot.add(PrayerNotificationModel.fromJson(item));
  });

  return PrayerSettingModel(
      backgroundWorking: json['backgroundWorking'] as bool,
      city: json['city'] as String,
      calMethod: json['calMethod'] as String,
      mazhab: json['mazhab'] as String,
      prayerVoice: json['prayerVoice'] as String,
      typeNotification: json['typeNotification'] as bool,
      listNotSet: listNot);
}
