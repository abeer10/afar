import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class StorageProvider {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future markAttendance(String dateNow, String timeNow, String year, String month) async {
    try{
      await firestore.collection('users').doc(auth.currentUser.uid).collection('attendance').doc(year).
      collection(month).doc(dateNow)
        .set(({
        'date': dateNow,
        'timeIn': timeNow,
        'timeOut' : null,
      })).then((value) {
        return "attendance marked";
      });
    }catch(e){
      return "Failed to mark attendance.";
    }
  }

  Future markAttendanceOut(String dateNow, String timeNow, String year, String month) async {
    try{
      await firestore.collection('users').doc(auth.currentUser.uid).collection('attendance').doc(year).
      collection(month).doc(dateNow)
          .update(({
//        'date': dateNow,
//        'timeIn': timeNow,
        'timeOut' : timeNow,
      })).then((value) {
        return "attendance marked";
      });
    }catch(e){
      return "Failed to mark attendance.";
    }
  }

  Future getUser() async {
   QuerySnapshot querySnapshot =  await firestore.collection("users").get();
    return querySnapshot.docs;
  }



}