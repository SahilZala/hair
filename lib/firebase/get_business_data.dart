import 'package:cloud_firestore/cloud_firestore.dart';

class GetBusinessData
{
  String userid;

  GetBusinessData(this.userid);
  
  Future<DocumentSnapshot> fetch_data() async => await FirebaseFirestore.instance.collection("business").doc(userid).get();
}
