import 'package:flutter/material.dart';
import 'package:myradius/util/FirebaseFirestoreGovernCollection.dart';
import 'package:myradius/ScanActivity/ScanQR.dart';
import 'package:myradius/Route.dart';
import 'package:myradius/model/UserModel.dart';
class Scan extends StatefulWidget{

   static final routeName = '/Scan';

   UserModel userobj; 

   Scan(user){
     userobj = user;
   } 

  _ScanState createState()=> _ScanState(userobj);
}


class _ScanState extends State<Scan>
{
UserModel userobj;   
_ScanState(user){
  userobj = user;
  _getRadius();
} 
FirebaseFirestoreGovernCollection gov = new FirebaseFirestoreGovernCollection();
double getRadiusInKM = 0.0;
double getRadiusInMeter;

void _getRadius()
  {
    //double radius;
    gov.getMCORadius().then((res) => {
      if(res.docs.length == 1)
      {
        res.docs.forEach((doc){
        var radiusInKM = doc['mco_radius']/1000;
        double radiusInMeter = doc['mco_radius'].toDouble();
        setState(() {
            getRadiusInKM = radiusInKM;
            getRadiusInMeter = radiusInMeter;
          });
         
        })
        }
      });

      
  }
  



  build(BuildContext context){
    return Scaffold(
      
    body: SingleChildScrollView(
      child: Column(
          children: <Widget>[
            Container(height: 40.0,
                    width: 100.0,
                   ),
              Container(height: 100.0,
                    width: 100.0,
                   
                    child: Image.asset('lib/img/MyRadius.png'),
                    
                    
                    ),
          Container(
          child: Text("MOVEMENT CONTROL ORDER RADIUS : "+getRadiusInKM.toString()+"KM",style:TextStyle(color: Colors.white, fontSize: 12,fontWeight: FontWeight.bold)),  
          padding: EdgeInsets.all(35),  
          margin: EdgeInsets.all(20),  
          decoration: BoxDecoration(  
            border: Border.all(color: Colors.black, width: 4),  
            borderRadius: BorderRadius.circular(8),  
            boxShadow: [  
              new BoxShadow(color: Colors.blue, offset: new Offset(6.0, 6.0),),  
            ],  
          )),
              
            Container(
              width: 700,
              color: Colors.black,
            ),
            
              Card(
                      child:ListTile(
                        title: Text("Scan QR",style: TextStyle(color: Colors.white),textAlign:TextAlign.center),
                        onTap: ()=>{

                          Navigator.of(context).push(createRoute(ScanQR(userobj,getRadiusInMeter)))    
                        },
                      ),
                      color:Colors.blue,
                      shape:new RoundedRectangleBorder(side: BorderSide(color: Colors.white),borderRadius: new BorderRadius.circular(0.0))),

          ],
    ) ,)


    );
  }
}