
import 'package:flutter/material.dart';

void DisplaySnackBar(context,message){

   final snackBar = SnackBar(
              content: Text(message),
              action: SnackBarAction(label: "Close", onPressed: (){})
            );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
}