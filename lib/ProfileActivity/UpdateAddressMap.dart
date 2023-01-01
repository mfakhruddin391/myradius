
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myradius/MapActivity/getCurrentLocation.dart';
import 'package:myradius/MapActivity/FindAddress.dart';
import 'package:myradius/Route.dart';
import 'dart:collection';
import 'package:myradius/util/FirebaseFirestoreUserCollection.dart';
import 'package:myradius/model/UserModel.dart';
class UpdateAddressMap extends StatefulWidget {
  
  
static const routeName  = '/UpdateAddressMap';

  @override
  _UpdateAdressMapState createState() => _UpdateAdressMapState();  
}

class _UpdateAdressMapState extends State<UpdateAddressMap>{

UserModel userObj;
FirebaseFirestoreUserCollection user = new FirebaseFirestoreUserCollection();
Completer<GoogleMapController> _controller = Completer();
String _addressTitle = "Please set your home's location";
var coords = {
    'lat' : 0.0,
    'lng' : 0.0,
  };
String _fullname;
String _email;
String _password;
String _place_id;

bool updateBtnStatus = false;

Set<Marker> addMarker = HashSet<Marker>();
Set<Circle> addCircle = HashSet<Circle>();

//forupdate
var getAddrssInfo = {
      'place_id' : '',
      'lat' : 0.0,
      'lng' : 0.0
    };


Future<void>_getCurrentLoc (controller) async  {

await getCurrentLocation().then((res)=>{

  coords['lat'] = res.latitude,
  coords['lng'] = res.longitude,

  }).then((res2)async{
    
  var complete =await _controller.future;
  var camera = CameraPosition(target: LatLng(coords['lat'],coords['lng']),zoom:14.4746);
   complete.animateCamera(CameraUpdate.newCameraPosition(camera));
  
}); 
}

GoogleMap showFullMap()
{
  return GoogleMap(
      mapType : MapType.normal,
      //initial location by set latlng default at the middle of peninsular malaysia
      initialCameraPosition : CameraPosition(target: LatLng(4.2105, 101.9758),zoom: 10.4746),
      markers: addMarker,
      circles: addCircle,
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: (GoogleMapController controller){
        _getCurrentLoc(controller);
        
       _controller.complete(controller);
      },
      padding: EdgeInsets.zero,
    );
}

void addMarkertoMap()
{
  addMarker.clear();
  addMarker.add(Marker(
    markerId: MarkerId(getAddrssInfo['place_id']),
    position: LatLng(getAddrssInfo['lat'],getAddrssInfo['lng']),
    icon: BitmapDescriptor.defaultMarker,
    ));
}

void addCircleToMap(){
  addCircle.clear();
  addCircle.add(Circle(
    circleId: CircleId(getAddrssInfo['place_id']),
    center: LatLng(getAddrssInfo['lat'],getAddrssInfo['lng']),
    //Radius data depend on malaysia Government. right now we use static data which is 10km.
    radius: 10000,
    strokeColor: Color(0xFF152451),
    strokeWidth: 3,
  ));
}

void searchAndRetreiveAddress() async{
  //bounce back to mapscreen using pop at findAddress
  var getAddressInfo = await Navigator.of(context).push(createRoute(FindAddress()));
  
  _addressTitle = getAddressInfo.address_name;
  //print(getAddressInfo.address_name);
  setState((){
    _place_id = getAddressInfo.place_id;
    //_addressTitle = getAddressInfo.address_name;
    coords['lat'] = getAddressInfo.lat;
    coords['lng'] = getAddressInfo.lng;
    getAddrssInfo['lat'] = getAddressInfo.lat;
    getAddrssInfo['lng'] = getAddressInfo.lng;
    getAddrssInfo['place_id'] = getAddressInfo.place_id;
    updateBtnStatus  = true;
  });

  var complete =await _controller.future;
  var camera   = CameraPosition(target: LatLng(getAddressInfo.lat,getAddressInfo.lng),zoom:11.5746);
  complete.animateCamera(CameraUpdate.newCameraPosition(camera));
  addCircleToMap();
  addMarkertoMap();
}

_onUpdate(context){



// UserModel send = new UserModel();
// send.setFullName(_fullname);
// send.setEmail(_email);
// send.setPassword(_password);
// send.setAddress(_addressTitle);
// send.setPlaceId(_place_id);
// send.setLat(coords['lat']);
// send.setLng(coords['lng']);

// Future<bool> verify = user.addUser(send);

// if(verify != null)
// {
//   DisplaySnackBar(context,"User registered successfully!");
//   return Navigator.of(context).push(createRoute(Login()));
// }
// return  DisplaySnackBar(context,"error! register user failed!");
// //
}





build(BuildContext buildContext){
//pass username and password from previous activity

 
  userObj = ModalRoute.of(context).settings.arguments;
  //_addressTitle = userObj.getAddress();

    return new Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        title: Text(_addressTitle,style: TextStyle(fontSize:15),),
        actions: <Widget>[
        IconButton(
          icon : const Icon(Icons.search),
          tooltip: 'Show',
          onPressed : ()
          {
           searchAndRetreiveAddress();
          }
        )  
        ],
      ),
      body: showFullMap(),
      bottomNavigationBar: BottomAppBar(
        
        color: Colors.white,
        child: TextButton(
          onPressed: (){
          updateBtnStatus? _onUpdate(context): print("error");
          },
          child: const Text("Update",style: TextStyle(fontSize: 15)),
          
        ),
      ),
    );
  }
}

