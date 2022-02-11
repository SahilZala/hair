import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';


import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService
{
  final FirebaseAuth _firebaseAuth;
  FirebaseAuthService(this._firebaseAuth);

  dynamic service;

  Future<String> signIn({required String email, required String pass})
  async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass).then((value) {
        service = value;
      });

      return "done";
    } on FirebaseAuthException catch(ex)
    {
      return ex.message.toString();
    }
  }

  Future<String> signUp({required String email, required String pass})
  async {
    try{
       await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass).then((value) {
         service = value;
       });

       return "done";
    } on FirebaseAuthException catch(ex)
    {
      print(ex.message);
      return ex.message.toString();
    }
  }


  Future<UserCredential> linkGoogle() async {
    // Trigger the Google Authentication flow.
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    // Create a new credential.
    final OAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Sign in to Firebase with the Google [UserCredential].
    final UserCredential googleUserCredential =
    await _firebaseAuth.signInWithCredential(googleCredential);

    return googleUserCredential;
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow

    FacebookLogin facebookLogin = new FacebookLogin();

    FacebookLoginResult facebookLoginResult = await facebookLogin.logIn();

    FacebookAccessToken? accessToken = facebookLoginResult.accessToken;

    AuthCredential credential = FacebookAuthProvider.credential(accessToken!.token);

    var a = await _firebaseAuth.signInWithCredential(credential);

    return a;

    //
    // // Create a credential from the access token
    // final facebookAuthCredential = FacebookAuthProvider.credential(result.);

    // Once signed in, return the UserCredential
    //return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

}