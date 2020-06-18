import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    controller.forward();

    controller.addStatusListener((status){
      if(status == AnimationStatus.completed){
        controller.forward(from: 0);
      } else if (status == AnimationStatus.dismissed){
        controller.forward();
      }
    });

    controller.addListener((){
      setState(() {

      });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'قم بتدوير هاتفك لتحسين دقة البوصلة بالحركة التالية',
                textAlign: TextAlign.center,
              ),
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(controller),
                child: Icon(Icons.my_location),
              ),
            ],
          ),
        ),
      ),
    );
  }
}