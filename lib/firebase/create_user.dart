import 'package:cloud_firestore/cloud_firestore.dart';

class CreatUser {
  String uid, ufirstname, ulastname, mobileno, emailaddress, password,
      accounttype,profile,activation,authwith;

  CreatUser(this.uid, this.ufirstname, this.ulastname, this.mobileno,
      this.emailaddress,
      this.password, this.accounttype,this.profile,this.activation,this.authwith);


  Future<String> pushData() async =>
      FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "firstname": ufirstname,
        "lastname": ulastname,
        "mobileno": mobileno,
        "emailaddress": emailaddress,
        "password": password,
        "accounttype": accounttype,
        "time": "time",
        "date": "date",
        "profile": profile,
        "authwith":authwith,
        "activation": activation
      }).then((value) {
        return "done";
      }).onError((error, stackTrace) {
        return error.toString();
      });



  Future checkUser() async =>
      FirebaseFirestore.instance.collection("users").doc(uid).get().then((
          value)  {
        if (value.data() == null) {
         return "reg";
        }
        else {
          if (value.get('accounttype') == "user") {
            return "user";
          }
          else {
            return "barber";
          }
        }
      }).onError((error, stackTrace) {
        return error.toString();
      });
  
  
  Future<QuerySnapshot<Map<String, dynamic>>> checkUserWithEmail()
  {
    return FirebaseFirestore.instance.collection("users").where("emailaddress",isEqualTo: emailaddress).get();
  }
  

}
