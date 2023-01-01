import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myradius/MapActivity/getCurrentLocation.dart';
import 'package:myradius/MapActivity/FindAddress.dart';
import 'package:myradius/Route.dart';
import 'dart:collection';
import 'package:myradius/util/FirebaseFirestoreUserCollection.dart';
import 'package:myradius/model/UserModel.dart';
import 'package:myradius/LoginActivity/Login.dart';
import 'package:myradius/util/FirebaseFirestoreGovernCollection.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class MapScreen extends StatefulWidget {
  
  
static const routeName  = '/MapScreen';

  @override
  _MapScreenState createState() => _MapScreenState();  
}

class _MapScreenState extends State<MapScreen>{

UserModel userObj = new UserModel();
FirebaseFirestoreGovernCollection gov = new FirebaseFirestoreGovernCollection();
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

double radius = 10000.0;

bool submitBtnStatus = false;

Set<Marker> addMarker = HashSet<Marker>();
Set<Circle> addCircle = HashSet<Circle>();

//forupdate
var getAddrssInfo = {
      'place_id' : '',
      'lat' : 0.0,
      'lng' : 0.0
    };

_MapScreenState(){
 radius = _getRadius();
}

double _getRadius()
  {
     double setRadius = 0;
    //double radius;
    gov.getMCORadius().then((res) => {
     
      if(res.docs.length == 1)
      {
        res.docs.forEach((doc){
        
        setRadius =  doc['mco_radius'].toDouble();
        print(radius);
        })
      }
    });

    return setRadius;
  }

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
      initialCameraPosition : CameraPosition(target: LatLng(4.2105, 101.9758),zoom: 14.4746),
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

void addMarkertoMap(getAddressInfo)
{
  addMarker.clear();
  addMarker.add(Marker(
    markerId: MarkerId(getAddressInfo.place_id),
    position: LatLng(getAddressInfo.lat,getAddressInfo.lng),
    icon: BitmapDescriptor.defaultMarker,
    ));
}

void addCircleToMap(getAddressInfo){
  addCircle.clear();
  addCircle.add(Circle(
    circleId: CircleId(getAddressInfo.place_id),
    center: LatLng(getAddressInfo.lat,getAddressInfo.lng),
    //Radius data depend on malaysia Government. right now we use static data which is 10km.
    radius: radius,
    strokeColor: Color(0xFF152451),
    strokeWidth: 3,
  ));
}

void searchAndRetreiveAddress() async{
  //bounce back to mapscreen using pop at findAddress
  var getAddressInfo = await Navigator.of(context).push(createRoute(FindAddress()));

  //print(getAddressInfo.address_name);
  setState((){
    _place_id = getAddressInfo.place_id;
    _addressTitle = getAddressInfo.address_name;
    coords['lat'] = getAddressInfo.lat;
    coords['lng'] = getAddressInfo.lng;
    
    submitBtnStatus  = true;
  });

  var complete =await _controller.future;
  var camera = CameraPosition(target: LatLng(getAddressInfo.lat,getAddressInfo.lng),zoom:11.5746);
  complete.animateCamera(CameraUpdate.newCameraPosition(camera));
  addMarkertoMap(getAddressInfo);
  addCircleToMap(getAddressInfo);
}

_onSubmit(context){
EasyLoading.show(status: 'Loading....');
FirebaseFirestoreUserCollection user = new FirebaseFirestoreUserCollection();
UserModel send = new UserModel();
send.setFullName(_fullname);
send.setEmail(_email);
send.setPassword(_password);
send.setAddress(_addressTitle);
send.setPlaceId(_place_id);
send.setLat(coords['lat']);
send.setLng(coords['lng']);

Future<bool> verify = user.addUser(send);

if(verify != null)
{
  EasyLoading.showSuccess('User registered Successfully!');
  return Navigator.pushReplacementNamed(context,Login.routeName);
}
return   EasyLoading.showSuccess('Error! User register failed.');
//
}





build(BuildContext buildContext){
//pass username and password from previous activity
 
  final UserModel getUser = ModalRoute.of(context).settings.arguments;
  _fullname= getUser.getFullName();
  _email = getUser.getEmail();
  _password= getUser.getPassword();


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
           submitBtnStatus? _onSubmit(context): print("error");

          },
          child: const Text("Submit",style: TextStyle(fontSize: 15)),
          
        ),
      ),
    );
  }
}

