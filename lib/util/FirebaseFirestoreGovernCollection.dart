
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreGovernCollection {


static FirebaseFirestore firestore;
CollectionReference governs;

FirebaseFirestoreGovernCollection()
{
  firestore  = FirebaseFirestore.instance;
  governs = firestore.collection('governs');
}


Future<QuerySnapshot> getMCORadius()
{
  return governs.orderBy("mco_radius").get()
  .then((res)=>res).catchError((onError) =>null);
}



}