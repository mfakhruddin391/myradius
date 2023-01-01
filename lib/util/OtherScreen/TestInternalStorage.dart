
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestInternalStorage extends StatefulWidget{

  static final routeName = '/TestInternalStorage';

  _TestInternalStorageState createState()=> _TestInternalStorageState();

}


class _TestInternalStorageState extends State<TestInternalStorage>{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
    home: Scaffold(
      body: Center(
      child: TextButton(
        onPressed: _incrementCounter,
        child: Text('Increment Counter'),
        ),
      ),
    ),
  );

  }


  _incrementCounter() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Pressed $counter times.');
  await prefs.setInt('counter', counter);
  }
}