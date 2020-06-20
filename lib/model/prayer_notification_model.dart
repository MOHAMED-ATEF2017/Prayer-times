class PrayerNotificationModel {
  int beforeAdhan, afterAdhan;
  bool alertByAdhan;

  PrayerNotificationModel({
    this.afterAdhan,
    this.alertByAdhan,
    this.beforeAdhan,
  });

  Map<String, dynamic> toJson() => _modelToJson(this);
  Map<String, dynamic> _modelToJson(PrayerNotificationModel model) {

    return <String, dynamic>{
      'afterAdhan':model.afterAdhan,
      'alertByAdhan':model.alertByAdhan ,
      'beforeAdhan': model.beforeAdhan,


    };
  }


  factory PrayerNotificationModel.fromJson(Map<String, dynamic> json) =>
      _modelFromJson(json);
}

PrayerNotificationModel _modelFromJson(Map<String, dynamic> json) {
  return PrayerNotificationModel(
      afterAdhan: json['afterAdhan'] as int,
      alertByAdhan: json['alertByAdhan'] as bool,
      beforeAdhan: json['beforeAdhan'] as int);
}
