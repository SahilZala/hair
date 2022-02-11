import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

Future<void> sendNotifications(String title,String body,String type,String via,String to,String from)
async {
  
  FirebaseFirestore.instance.collection("users").doc(to).get().then((value) async {
    if(value.data() != null)
    {
      if(value.data()!['token'] != null)
      {
        Map<String,String> header = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'key=AAAAnm8FFZs:APA91bHBwG64Fhp8p8RXubcs5xsF9ku879-mExjJUvhhOY1BDUl-QAQbCMILwY2dAFOiCpwwvyy89p9noihtdzZiNqSx8_uMFxu5WHv6lCMkeNgWvvSguSLwwTtdjwpX9i5YtRzaYs6i'
        };

        var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
        await http.post(url, body: jsonEncode({
          'to': '${value.data()!['token']}',
          'data': {
            'via': via,
            'type': type,
            'to': to,
            'user': from
          },
          'notification': {
            'title': title,
            'body': body,
          },
        }),headers: header).then((value){
          print('Response status: ${value.statusCode}');
          print('Response body: ${value.body}');

          createNotification(title,body,type,via,to,from).then((val){
            print("done ${value.statusCode}");
          });

        });
      }
    }
  });
}


Future<void> createNotification(String title,String body,String type,String via,String to,String from)
async {
  String nid = Uuid().v1();
  return await FirebaseFirestore.instance.collection("notification").doc(to).collection("notification").doc(nid).set({
    'title': title,
    'body' : body,
    'type' : type,
    'via' : via,
    'to' : to,
    'from' : from,
    'date' : "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}",
    'time' : "${DateTime.now().hour} : ${DateTime.now().minute}",
    'visible': 'false',
    'nid': nid
  });
}

Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNotification(String vendorid)
async {
  return await FirebaseFirestore.instance.collection("notification").doc(vendorid).collection("notification").snapshots();
}