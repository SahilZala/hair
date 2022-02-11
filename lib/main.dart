import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hair/authentication/seggrigation.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/home/new_new_user_home.dart';

import 'invoice/pdf_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDaMo2ieMUUTnPYEfTdLWgI8oZYAgp4uJw',
        appId: '1:680467436955:android:84c087b6646a5a34f8bd3e',
        messagingSenderId: '680467436955',
        projectId: "hair-app-9da6e",
      ));
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: Segrigation()
       // home: PdfPage(),
    );
  }
}

