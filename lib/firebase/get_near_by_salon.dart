import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Stream<QuerySnapshot<Map>> getNearBySalon()
{
  return FirebaseFirestore.instance.collection("business").snapshots();
}


Stream<QuerySnapshot<Map>> getHistoryVisit(String userid)
{
  return FirebaseFirestore.instance.collection("users").doc(userid).collection("visithistory").snapshots();
}


Stream<QuerySnapshot<Map>> getSalonGallaryImage(String vendorid)
{
  return FirebaseFirestore.instance.collection("gallery")
      .doc(vendorid)
      .collection("gallery").snapshots();
}


Stream<DocumentSnapshot<Map>> getSalonDetails(String salonid)
{
  return FirebaseFirestore.instance.collection("business").doc(salonid).snapshots();
}



Stream<QuerySnapshot<Map>> getPackageData(String vendorid)
{
  return FirebaseFirestore.instance.collection("packages")
      .doc(vendorid)
      .collection("package").snapshots();
}

