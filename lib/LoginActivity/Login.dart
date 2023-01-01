import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myradius/DashboardActivity/Dashboard.dart';
import 'package:myradius/RegisterActivity/Register.dart';
import 'package:myradius/Route.dart';
import 'package:myradius/util/FirebaseFirestoreUserCollection.dart';
import 'package:myradius/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class Login extends StatefulWidget {

  static const routeName  = '/Login';

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login>{
  
  FirebaseFirestoreUserCollection users = new FirebaseFirestoreUserCollection();
  UserModel userObj = new UserModel();

_LoginState(){
  _fingerprintAuth();
}

//shared preferences
Future _fingerprintAuth() async{
 
  var localAuth = LocalAuthentication();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int status = await prefs.getInt('biometricStatus') ?? 0;
  //print(status);
  if(status != null)
  {
    print("yes it is not null");
    if(status != 0)
    {
      String email = await prefs.getString('email');
      String pw    = await prefs.getString('pw');
      // print(email);
      // print(pw);
      // print("yes it is not 0");
      //return status to 1 if fingerprint match 
        bool fingerprintauth = await localAuth.authenticate(
          localizedReason: "Please put your fingerprint on the sensor",
          options: const AuthenticationOptions(
          stickyAuth: true,
          sensitiveTransaction:true,
          biometricOnly: true,
        ),);
        print(fingerprintauth);
        
        if(fingerprintauth)
        {
           userObj.setEmail(prefs.getString('email')); 
           userObj.setPassword(prefs.getString('pw'));
           userLogin(context);

        }

        if(!fingerprintauth){
          SystemNavigator.pop();
        }
    }

   


  }


    

  }

 
  userLogin(context){
    if(userObj.getEmail().length != 0 && userObj.getPassword().length !=0)
    { 
    EasyLoading.show(status: 'Loading....');
    users.loginAuth(userObj).then((res){
      EasyLoading.showProgress(0.3,status: 'Loading....');
      //data.docs.forEach((doc)
      print(res.docs.length);
      if(res.docs.length == 1)
      {
        EasyLoading.dismiss();
        return res.docs.forEach((doc){
        userObj.setFullName(doc['fullname']);
        userObj.setEmail(doc['email']);
        userObj.setPassword(userObj.getPassword());
        userObj.setAddress(doc['coord_info']['home_address']);
        userObj.setLat(doc['coord_info']['lat']);
        userObj.setLng(doc['coord_info']['lng']);
        userObj.setPlaceId(doc['coord_info']['place_id']);
        userObj.setActivity("login");

         //return Navigator.pushNamed(context,Dashboard.routeName,arguments: userObj);
         return Navigator.pushReplacementNamed(context,Dashboard.routeName,arguments: userObj);
         });
      }

      if(res == null)
      {
        EasyLoading.showError('Network Failed.');
      } 

      if(res.docs.length == 0){

      EasyLoading.showError('Incorrect email or password.');
      }

    });
    } else {
       EasyLoading.showError('Please insert email and password!');
    }
  }


  @override 
  Widget build(BuildContext context){
    
    return Scaffold(
      
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : Text("Login Page"),
      ),
      body: SingleChildScrollView(
        
        child: Column(
          
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('lib/img/MyRadius.png')),
              ),
            ),
             Container(height: 40.0,
                    width: 100.0,
                    color: Colors.white),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your email'),
                    onChanged: (val){
                      setState((){
                        userObj.setEmail(val);  
                      });

                    },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                    onChanged: (val){
                      setState((){
                        userObj.setPassword(val);  
                      });
                    },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                key: Key("loginbtn1"),
                
                onPressed: () {
                  userLogin(context);
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            new InkWell(
              child : new Text('New User? Create Account'),
              onTap: () => 
              {
                Navigator.of(context).push(createRoute(Register())),
              }
            )

          ],),)

    );
  }


}