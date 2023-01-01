
import 'package:flutter/material.dart';

import 'package:myradius/MapActivity/MapScreen.dart';

import 'package:myradius/model/UserModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myradius/util/FirebaseFirestoreUserCollection.dart';
class Register extends StatefulWidget {

  static const routeName  = '/Register';

  @override
  _RegisterState createState() => _RegisterState();

}

class _RegisterState extends State<Register>{
  FirebaseFirestoreUserCollection users = new FirebaseFirestoreUserCollection();
  UserModel user = new UserModel();
  String _fullname = "";
  String _email = "";
  String _password = "";
  String _strongLevel = "";
  double _stronglvlDigit = 0.0;
  String _rePassword = "";

saveUser(context){
EasyLoading.show(status: 'Loading....');
  
if(_fullname.length>0 && _email.length > 0){
  if(_password == _rePassword)
  {  
  user.setEmail(_email);
  
  users.getUserInfo(user).then((res){
    
    if(res.docs.length == 1)
    {
      return EasyLoading.showError("the email already registered on the system");

    } else {

  user.setFullName(_fullname);
  user.setPassword(_password);
  user.setActivity('register');
  EasyLoading.dismiss();
  return Navigator.pushNamed(context,MapScreen.routeName,arguments: user);
  

    }
  
  
  });

  
  }else {
  return EasyLoading.showError("Password & Re-enter Password must same!");
  }
    }else { 
      return EasyLoading.showError("Please insert all required field!");
    }
  }
  
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : Text("Register Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 50,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Text("Register Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 25),)),
              ),
            ),
             Container(height: 5.0,
                    width: 100.0,
                    color: Colors.white),
                     Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full name',
                    hintText: 'Enter your full name'),
                    onChanged: (val){
                      setState((){
                        _fullname = val;
                      });
                    },
              ),
            ),
                   
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
               padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                onSubmitted: (val){
                  print("submited..");
                },
                onEditingComplete: (){
                  print("editcomplete..");
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your Email'),
                    onChanged: (val){
                      setState((){
                        _email = val;
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
                      setState(() {
                        _password = val;
                      });
                    },
              ),
            ),
            Container(height: 2.0,
                    width: 20.0,
                    color: Colors.white),
             Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Re-enter Password',
                    hintText: ''),
                    onChanged: (val){
                      setState(() {
                        _rePassword = val;
                      });
                    },
              ),
            ),
          Container(height: 40.0,
                    width: 100.0,
                    color: Colors.white),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: (){

               saveUser(context);

              },
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 25)
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],),)

    );
  }


}