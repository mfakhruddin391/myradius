import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Pass the page or activity in the parameter
//this is including the animation for sliding to other page
Route createRoute(passActivity){
  return PageRouteBuilder(
      pageBuilder: (context,animation,secondaryAnimation) => passActivity,
      transitionsBuilder: (context,animation,secondaryAnimation,child){
        var begin = Offset(0.0,1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin:begin,end:end).chain(CurveTween(curve:curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: animation.drive(tween),
          child:child,
        );
      }
  );
}