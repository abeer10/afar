import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


//class YourApp extends StatelessWidget{
//
//  @override
//  Widget build(BuildContext context){
//    return FutureBuilder<User>(
//        future: FirebaseAuth.instance.currentUser(),
//        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
//          if (snapshot.hasData){
//            FirebaseUser user = snapshot.data; // this is your user instance
//            /// is because there is user already logged
//            return MainScreen();
//          }
//          /// other way there is no user logged.
//          return LoginScreen();
//        }
//    );
//  }
//}