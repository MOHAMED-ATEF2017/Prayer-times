import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah_example/qiblah/qiblah_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';



class LocationErrorWidget extends StatelessWidget {
  final String error;
  final Function callback;

  const LocationErrorWidget({Key key, this.error, this.callback})
      : super(key: key);





  @override
  Widget build(BuildContext context) {
    Location location = new Location();

    bool _serviceEnabled;
    void checkPermission() async{


      await Geolocator().checkGeolocationPermissionStatus();
      _serviceEnabled = await location.serviceEnabled();
      print(_serviceEnabled);
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        print(_serviceEnabled);
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



    return Center(
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                SizedBox(height: 20,),

                Text(
                  'يريد التطبيق الوصول إلى موقعك',
                  style: TextStyle(
                      fontFamily: 'Sukar',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black
                  ),
                ),
                SizedBox(height: 20,),


                Image.asset('assets/locationalrt.png',width: MediaQuery.of(context).size.width*0.45,),
                SizedBox(height: 25,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          SystemNavigator.pop();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width*.437,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                            color: Color(0xFFBFBFBF),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'عدم السماح',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Sukar',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: ()=>checkPermission(),
                        child: Container(
                          width: MediaQuery.of(context).size.width*.437,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                            color: Color(0xFF4EA1B5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "السماح",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Sukar',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                            ),


                          ),
                        ),
                      )

                    ],
                  ),

                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}