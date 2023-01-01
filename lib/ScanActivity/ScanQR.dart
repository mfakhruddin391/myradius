import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:haversine/haversine.dart';
import 'package:myradius/MapActivity/getCurrentLocation.dart';
import 'package:myradius/model/UserModel.dart';
import 'package:myradius/ScanActivity/ScanResult.dart';
class ScanQR extends StatefulWidget{

static final routeName = "/ScanQR";
UserModel userobj;
Haversine haversine;
double radius = 0.0;

ScanQR(user,bindRadius){
userobj = user;
radius = bindRadius;
}

_ScanQRState createState() => _ScanQRState(userobj,radius);

}



class _ScanQRState extends State<ScanQR>{

final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
Barcode result;
QRViewController controller;
UserModel userobj;
Haversine haversine;

_ScanQRState(user,bindRadius){
    userobj = user;
    radius = bindRadius;
   
  }

  dynamic distance;
  double radius = 0.0;
  var coords = {
    'lat' : 0.0,
    'lng' : 0.0,
  };

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
Future<void>_getCurrentLoc () async  {

await getCurrentLocation().then((res)=>{

  coords['lat'] = res.latitude,
  coords['lng'] = res.longitude,

  }).then((res2){
    haversine = Haversine.fromDegrees(
        latitude1: userobj.getLat(),
        longitude1: userobj.getLng(),
        latitude2: coords['lat'],
        longitude2: coords['lng'],);
  });
}

_checkDistance(scanData){
  print("Scanned!");
  //print(scanData.code.locationName);

  print(scanData.code);
 
  double distance = haversine.distance();
  print(radius);
  print(distance);

dynamic sendResult = {
  'locationName' : scanData.code,
  'isInsideRadius' : true,
  'mco_radius' : radius,
  'distance' : distance,
  'fullName' : userobj.getFullName(),
  'home_address':userobj.getAddress(),
  'home_coords' : {
    'lat' : userobj.getLat(),
    'lng' : userobj.getLng(),
  },
  'cur_coords' : {
    'lat' : coords['lat'],
    'lng' : coords['lng'],
  }
};


distance > radius? sendResult['isInsideRadius'] = false : sendResult['isInsideRadius'] = true;

Navigator.popAndPushNamed(context,ScanResult.routeName,arguments: sendResult);
}


  @override
  Widget build(BuildContext context) {
     
    print(userobj.getLat());
    print(userobj.getLng());
    print(coords);

    _getCurrentLoc();


    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
    
    _checkDistance(scanData);


      setState(() {
        result = scanData;
      });
    });

  

  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

