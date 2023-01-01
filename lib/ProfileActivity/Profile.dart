
import 'package:flutter/material.dart';
import 'package:myradius/model/UserModel.dart';
import 'package:myradius/util/FirebaseFirestoreUserCollection.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class Profile extends StatefulWidget {

static final routeName = "/Profile";
static UserModel userObj;
Profile(UserModel user){

userObj = user;

}

_ProfileState createState() => _ProfileState(userObj);

}


class _ProfileState extends State<Profile>{


UserModel userObj;
FirebaseFirestoreUserCollection readUser;

_ProfileState(UserModel user){
  userObj= user;
  user.setActivity('profile');  
  _initCurrentStatusBiometric();
}

 bool biometricStatus = false;

Future<bool> cancheck() async{
bool checking = await LocalAuthentication().canCheckBiometrics;
return checking;
}

String _fname;  
String _email;  
int statusInInt = 0;

//shared preferences
Future _saveBiometricStatus(context,status) async{
  //status? statusInInt = 1: statusInInt = 0;
  
  var localAuth = LocalAuthentication();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if(status)
  {
  //Initialize biometric library to check availability of the sensor on the smartphone.  
  List<BiometricType> availableBiometrics = await LocalAuthentication().getAvailableBiometrics();

  //check if the devices have fingerprint sensor built-in
  if(availableBiometrics.contains(BiometricType.fingerprint)){
    if(prefs.getInt('biometricStatus') == null || prefs.getInt('biometricStatus') == 0)
    {
      
      await localAuth.authenticate(
        localizedReason: "Please put your fingerprint on the sensor",
        options: const AuthenticationOptions(
        stickyAuth: true,
        sensitiveTransaction:true,
        biometricOnly: true,
        ),
       
         ).then((res){
        prefs.setInt('biometricStatus',1);
        prefs.setString('email',userObj.getEmail());
        prefs.setString('pw',userObj.getPassword());
        setState(() {
        biometricStatus = true; 
        });
        
      });
      
    }
  
  } else {
    
  await prefs.setInt('biometricStatus', 0);
  await prefs.remove('email');
  await prefs.remove('pw');

  EasyLoading.showError("Fingerprint is not available on device");
  setState(() {biometricStatus = false; });
  }
  
  
  
  } else {
    setState(() {biometricStatus = false; });
    await prefs.setInt('biometricStatus', 0);
    await prefs.remove('email');
    await prefs.remove('pw');
  }

  setState(() {biometricStatus = status; });
  
  
  }

//Get current status of biometric fingerprint state
Future<void> _initCurrentStatusBiometric() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getInt('biometricStatus') == null || prefs.getInt('biometricStatus') == 0)
  {
    this.setState(() {
       biometricStatus = false;
    });
   
  } else {
    this.setState(() {
       biometricStatus = true;
    });
  }
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 50,
                  
                    child: Text("View Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 25),)),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    //labelText: 'Email',
                    hintText: "Email :"+userObj.getEmail()),
                    onChanged: (val){
                      setState((){
                       //userObj.setEmail(val);
                       _email = val;
                      });

                    },
              ),
            ),
                     Padding(
                        padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    //labelText: 'Full name',
                    hintText: "Full name :"+userObj.getFullName()),
                    onChanged: (val){
                      setState((){
                       _fname = val;
                      });
                    },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                enabled: false,
                obscureText: true,
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: userObj.getAddress()),  
              ),
            ),         
             Container(height: 40.0,width: 200.0),
            Row(children: [
               Container(height: 40.0,
                    width: 20.0,
                    color: Colors.white),
            Text("Enable Biometrics Fingerprint",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 20),),
             Container(height: 40.0,
                    width: 20.0,
                    color: Colors.white),
            FlutterSwitch(
              
              
              width: 70.0,
              height: 35.0,
              value: biometricStatus,
              showOnOff: true,
              onToggle: (val){
                
              _saveBiometricStatus(context,val);
              })
            ],
            )
            
          ]
          ,) 
          ,
    );
    
  }

}