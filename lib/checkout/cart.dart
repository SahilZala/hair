import 'package:cloud_firestore/cloud_firestore.dart';

class Cart
{

  String vendorid = "";
  String servicetype = "";
  String gender = "";
  String salonid = "";
  List<String> serviceid = [];
  String cartid = "";
  String status = "";
  String activation = "";

  Cart(this.vendorid, this.servicetype, this.gender, this.salonid,
      this.serviceid, this.cartid, this.status, this.activation);

  Future<void> push()
  {
    return FirebaseFirestore.instance
        .collection("cart")
        .doc(vendorid)
        .collection("cart")
        .doc(salonid)
        .set({
      'vendorid': vendorid,
      'servicetype': servicetype,
      'gender': gender,
      'salonid': salonid,
      'serviceid': serviceid,
      'cartid': cartid,
      'status': status,
      'activation': activation
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCart(String vid)
  {
    return FirebaseFirestore.instance
        .collection("cart")
        .doc(vid)
        .collection("cart").snapshots();
  }

  Cart.non();
}