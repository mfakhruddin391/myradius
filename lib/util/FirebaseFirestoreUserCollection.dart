import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:myradius/model/UserModel.dart';

class FirebaseFirestoreUserCollection {

static FirebaseFirestore firestore;
CollectionReference users;

FirebaseFirestoreUserCollection()
{
  firestore  = FirebaseFirestore.instance;
  users = firestore.collection('users');
}

Future<bool> addUser(UserModel user){

  var bytes = utf8.encode(user.getPassword());
  var encrypt = sha256.convert(bytes);

   return users.add({
      'fullname' : user.getFullName(),
      'email' : user.getEmail(),
      'password': encrypt.toString(),
      'coord_info' : {
        'home_address' : user.getAddress(),
        'lat' : user.getLat(),
        'lng' : user.getLng(),
        'place_id' : user.getPlaceId(),
      }
    }).then((value) => true)
    .catchError((onError)=> null);
  }

Future<QuerySnapshot> loginAuth(UserModel user)
{
  var bytes = utf8.encode(user.getPassword());
  var encrypt = sha256.convert(bytes);

  return users.where('email',isEqualTo: user.getEmail())
  // data.docs.forEach((doc)
  .where('password',isEqualTo:encrypt.toString()).get()
  .then((data)=> data).catchError((onError) => null);
}

Future<QuerySnapshot> getUserInfo(UserModel user)
{
  return users.where('email',isEqualTo: user.getEmail()).get()
  .then((data)=> data).catchError((onError) =>null);
}


}