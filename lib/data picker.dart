//import 'package:flutter/material.dart';
//import 'package:hijri/umm_alqura_calendar.dart';
//import 'package:hijri_picker/hijri_picker.dart';
//
//class CalenderPicker extends StatefulWidget {
//  @override
//  _CalenderPickerState createState() => _CalenderPickerState();
//}
//
//class _CalenderPickerState extends State<CalenderPicker> {
// UmmAlquraCalendar selectedDate = UmmAlquraCalendar.now();
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Center(
//        child: FlatButton(
//          onPressed: () async {
//            final UmmAlquraCalendar picked = await showHijriDatePicker(
//
//              context: context,
//              initialDate: selectedDate,
//              textDirection: TextDirection.rtl,
//              lastDate: new UmmAlquraCalendar()
//                ..hYear = 1442
//                ..hMonth = 9
//                ..hDay = 25,
//              firstDate: new UmmAlquraCalendar()
//                ..hYear = 1438
//                ..hMonth = 12
//                ..hDay = 25,
//              initialDatePickerMode: DatePickerMode.day,
//
//            );
//            print(picked);
//            if (picked != null)
//              setState(() {
//                selectedDate = picked;
//              });
//          },
//          child: Text('data'),
//        ),
//      ),
//    );
//  }
//}
