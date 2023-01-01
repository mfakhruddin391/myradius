import 'package:flutter/material.dart';
import 'package:myradius/DashboardActivity/Vaccine.dart';
import 'package:myradius/LoginActivity/Login.dart';
import 'package:myradius/ScanActivity/Scan.dart';
import 'package:myradius/ProfileActivity/Profile.dart';
import 'package:myradius/model/UserModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
static const routeName = '/Dashboard';


_DashboardScreenState createState() => _DashboardScreenState();

}

class _DashboardScreenState extends State<Dashboard> {
 SharedPreferences prefs; 
 static UserModel userObj = new UserModel();
 int _selectedIndex = 0;

 _DashboardScreenState()
 {
   getPreferences();
 }


 Future getPreferences() async{

   prefs = await SharedPreferences.getInstance();


 }

 Future logout() async{
  await prefs.setInt('biometricStatus', 0);
  await prefs.remove('email');
  await prefs.remove('pw');
 
  EasyLoading.showSuccess("Logout Successfully");
  Navigator.pushReplacementNamed(context,Login.routeName);
 
 }


 
static List<Widget> _widgetOptions = <Widget>[
    Scan(userObj),
    Vaccine(),
    Profile(userObj),
  ];

 void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 @override
 Widget build(BuildContext context) {

    userObj = ModalRoute.of(context).settings.arguments;
    if(userObj.getActivity()=="login")
    {
      EasyLoading.showSuccess("Login Successfully");
      userObj.setActivity("");
    }

     return Scaffold(
      appBar: AppBar(
        
        title: const Text('MyRadius'),
        actions: <Widget>[
        IconButton(
          icon : const Icon(Icons.logout),
          tooltip: 'Show',
          onPressed : ()
          {
           logout();
          }
        )  
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Vaccine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Profile',
          ),    
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ));
      }

}