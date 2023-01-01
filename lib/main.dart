import 'package:flutter/material.dart';
import 'package:myradius/LoginActivity/Login.dart';
import 'package:myradius/RegisterActivity/Register.dart';
import 'package:myradius/MapActivity/MapScreen.dart';
import 'package:myradius/MapActivity/FindAddress.dart';
import 'package:myradius/DashboardActivity/Dashboard.dart';
import 'package:myradius/ProfileActivity/UpdateAddressMap.dart';
import 'package:myradius/ScanActivity/ScanResult.dart';
import 'package:myradius/ScanActivity/CheckMap.dart';
import 'package:myradius/model/UserModel.dart';
import 'package:myradius/util/OtherScreen/LoadingClass.dart';
import 'package:myradius/util/OtherScreen/LostConnection.dart';
import 'package:myradius/ScanActivity/ScanQR.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppsInit());


}

class AppsInit extends StatelessWidget{


  //Initialize firebase
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  UserModel user = new UserModel();
  double radius = 0.0;


 MaterialApp _establishApps(context){
 
    return MaterialApp(
        home: Login(),

        routes: {
          Login.routeName : (context) => Login(),
          Register.routeName : (context) => Register(),
          MapScreen.routeName : (context) => MapScreen(),
          FindAddress.routeName : (context) => FindAddress(),
          Dashboard.routeName : (context) => Dashboard(),
          UpdateAddressMap.routeName : (context) => UpdateAddressMap(),
          ScanQR.routeName : (context)=> ScanQR(user,radius),
         // Vaccine.routeName : (context) => Vaccine(),
          LostConnection.routeName : (context) => LostConnection(),
          LoadingClass.routeName : (context) =>LoadingClass(),
          ScanResult.routeName : (context)=>ScanResult(),
          CheckMap.routeName : (context)=>CheckMap(),
        },
        builder: EasyLoading.init(),

      ); 
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future :_initialization, 
      builder: (context,snapshot){

        print("waiting...");

        if(snapshot.hasError){
         print("Error!");

         return LostConnection();
         
        }

        if(snapshot.connectionState == ConnectionState.done)
        {
          print("Done!");

         return _establishApps(context);
        }

        return Container();
      }
    );

  }


}