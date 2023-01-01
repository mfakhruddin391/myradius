import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:collection';
import 'package:myradius/model/UserModel.dart';
import 'package:myradius/util/FirebaseFirestoreGovernCollection.dart';

class CheckMap extends StatefulWidget {
  
  
static const routeName  = '/CheckMap';

  @override
  _CheckMapState createState() => _CheckMapState();  
}

class _CheckMapState extends State<CheckMap>{

UserModel userObj = new UserModel();
FirebaseFirestoreGovernCollection gov = new FirebaseFirestoreGovernCollection();
Completer<GoogleMapController> _controller = Completer();

dynamic sendResult;

String _fullname;
String _email;
String _password;
String _place_id;

double radius = 10000.0;

Set<Marker> addMarker = HashSet<Marker>();
Set<Circle> addCircle = HashSet<Circle>();
Set<Polyline> addPolyline = HashSet<Polyline>();


Future<void>_getCurrentLoc(controller) async  {

 print("in _getCurrentLoc..");
 print(sendResult);
  var complete =await _controller.future;
  var camera = CameraPosition(target: LatLng(sendResult['cur_coords']['lat'],sendResult['cur_coords']['lng']),zoom:10.4746);
  complete.animateCamera(CameraUpdate.newCameraPosition(camera));
  

}

void addMarkertoMap()
{
  addMarker.clear();
  addMarker.add(Marker(
    markerId: MarkerId("marker1"),
    position: LatLng(sendResult['home_coords']['lat'],sendResult['home_coords']['lng']),
    infoWindow: InfoWindow(title:"Your home"),
    icon: BitmapDescriptor.defaultMarkerWithHue(200)
    ));
    addMarker.add(Marker(
    markerId: MarkerId("marker2"),
    position: LatLng(sendResult['cur_coords']['lat'],sendResult['cur_coords']['lng']),
    infoWindow: InfoWindow(title:"Your current location")
    ));
}

void addPolyLinetoMap()
{
  addPolyline.clear();
  addPolyline.add(Polyline(
    polylineId: PolylineId("polyline1"),
    points: [LatLng(sendResult['home_coords']['lat'],sendResult['home_coords']['lng']),LatLng(sendResult['cur_coords']['lat'],sendResult['cur_coords']['lng'])],
    color: Color(0xFF152451),
    width: 3,
    ));
}

void addCircleToMap(){
  addCircle.clear();
  addCircle.add(Circle(
    circleId: CircleId("circle1"),
    center: LatLng(sendResult['home_coords']['lat'],sendResult['home_coords']['lng']),
    //Radius data depend on malaysia Government. right now we use static data which is 10km.
    radius: sendResult['mco_radius'].toDouble(),
    strokeColor: sendResult['isInsideRadius']? Color(0xFF152451):Colors.red,
    strokeWidth: 3,
  ));
  
}


GoogleMap showFullMap()
{
  return GoogleMap(
      mapType : MapType.normal,
      //initial location by set latlng default at the middle of peninsular malaysia
      initialCameraPosition : CameraPosition(target: LatLng(4.2105, 101.9758),zoom: 14.4746),
      markers: addMarker,
      circles: addCircle,
      polylines: addPolyline,
     // myLocationEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: (GoogleMapController controller){
        _getCurrentLoc(controller);
       _controller.complete(controller);
      },
      padding: EdgeInsets.zero,
    );
}





build(BuildContext buildContext){
//pass username and password from previous activity
  
    sendResult = ModalRoute.of(context).settings.arguments;
    
    print("in build..");
    print(sendResult);
    addMarkertoMap();
    addCircleToMap();
    addPolyLinetoMap();
  //print(sendResult);


    return new Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        title: Text("Check Map"),
        centerTitle: true,
        backgroundColor: sendResult['isInsideRadius']? null:Colors.red,
        ),
      body: showFullMap(),
    );
  }
}

