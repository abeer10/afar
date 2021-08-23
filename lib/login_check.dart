import 'package:afar/Screens/User/login.dart';
import 'package:afar/Screens/User/staff_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Screens/Admin/admin_view.dart';


class CheckLogin extends StatefulWidget{

  @override
  _CheckLoginState createState() => _CheckLoginState();
}


class _CheckLoginState extends State<CheckLogin> {


  checkUser() async {
   var user =  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).get();
   if(user.exists){
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(
         builder: (context) => StaffView(),
       ),
     );
   } else {
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(
         builder: (context) => AdminView(),
       ),
     );
   }


  }


@override
  void initState() {
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
    if (user == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
          builder: (context) => Login(),
    ));
    } else {
     checkUser();
    }
  });
  // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context){
   return Scaffold(
     body: Center(
       child: CircularProgressIndicator(),
     ),
   );
  }
}