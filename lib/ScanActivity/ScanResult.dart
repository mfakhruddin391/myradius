
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:myradius/ScanActivity/CheckMap.dart';
class ScanResult extends StatefulWidget {

static final routeName = '/ScanResult';

_ScanResultState createState()=> _ScanResultState();

}


class _ScanResultState extends State<ScanResult>{
  
String locationName;
dynamic getResult;
bool isInsideRadius;
double currMCORadius;
double distanceFromHouse;
String fullname;
  

double roundDouble(double value, int places){ 
   double mod = pow(10.0, places); 
   return ((value * mod).round().toDouble() / mod); 
}


  @override
  Widget build(BuildContext context) {
  getResult = ModalRoute.of(context).settings.arguments;
  isInsideRadius = getResult['isInsideRadius'];
  currMCORadius = roundDouble(getResult['mco_radius']/1000,2);
  distanceFromHouse = roundDouble(getResult['distance']/1000,2);
  fullname = getResult['fullName'];
  locationName = getResult['locationName'];

  return Scaffold(
    appBar: AppBar(
      title: Text(isInsideRadius? "You are inside Radius" : "You are outside radius!"),
      centerTitle: true,
      backgroundColor:!isInsideRadius? Colors.red[200]:null ,
    ),
    backgroundColor:!isInsideRadius?  Colors.red[900]:null,
    body: Column(
      
      
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(.2),
              width: 1,
            ),
          ),
          child: Container(
            width: 400,
            height: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 13.0, 8.0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        width: 60.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: isInsideRadius? Icon(Icons.thumb_up_alt_rounded,color: Colors.green,) : 
                          Icon(Icons.warning_amber_rounded,color: Colors.red,size: 30.0)),
                          // child: Icon(
                          //   Icons.warning_amber_rounded,
                          //   color: Colors.red,
                          //   size: 30.0
                          // ),
                          // child: Image.asset('lib/img/MyRadius.png'),
                        ),
                      
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 6.0, 0, 0),
                            child:Row(children: [
                               Text(locationName.length > 0? locationName.toUpperCase():'',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            
                            ],)),
                          
                          Text("Time : "+DateTime.now().toString(),
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: .2,
                  indent: 8,
                  endIndent: 8,
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget> [
                            Text(
                          'Current MCO Radius:',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(
                        width: 100,
                        ),
                        Text(
                          'Distance From House :',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                       
                        ],),
                        SizedBox(
                        height: 10,
                        ),
                        Row(children:<Widget> [
                           Text(
                          currMCORadius.toString()+"KM",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                        width: 200,
                        ),
                          Text(
                          distanceFromHouse.toString()+"KM",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ],),
                        SizedBox(
                        height: 15,
                        ),
                       Text(
                          'Name:',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(
                        height: 10,
                        ),
                        Text(
                          fullname,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                        ), SizedBox(
                        height: 10,
                        ),
                       
                        
                        
                      ],
                    ),
                  ),
                ),
                 Divider(
                   color: Colors.black,
                   thickness: .2,
                   indent: 8,
                   endIndent: 8,
               ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,CheckMap.routeName,arguments: getResult);
                          },
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 2.0),
                                  child: Icon(
                                    Icons.map_outlined,
                                    size: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'check Map',
                                  style: TextStyle(color: Colors.grey[700]),
                                  
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));


  
  }
}