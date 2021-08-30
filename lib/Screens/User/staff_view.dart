import 'dart:async';

import 'package:afar/Providers/AuthProvider.dart';
import 'package:afar/Providers/StorageProvider.dart';
import 'package:afar/Screens/Admin/admin_view.dart';
import 'package:afar/Screens/User/login.dart';
import 'package:afar/Screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';

// import 'package:image_picker/image_picker.dart';

class StaffView extends StatefulWidget {
  @override
  _StaffViewState createState() => _StaffViewState();
}

class _StaffViewState extends State<StaffView> {
  var dateNow;
  var year;
  var month;
  var timeNow;
  DateTime now;
  int weekday, attendance;
  var percentage = 0.0;
  String mark, out;
  StreamSubscription<GeofenceStatus> geofenceStatusStream;
  Geolocator geolocator = Geolocator();
  String geofenceStatus = '';
  bool isReady = false;
  Position position;

  CollectionReference user = FirebaseFirestore.instance.collection('users');
  Future getAttendance() async {
    print(year);
    print(month);
    QuerySnapshot querySnapshot = await user
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("attendance")
        .doc(year)
        .collection(month)
        .get();
    print(querySnapshot.docs.length);

    return querySnapshot.docs;
  }

  getDailyAttendance() async {
    print("In");
    DocumentSnapshot documentSnapshot = await user
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("attendance")
        .doc(year)
        .collection(month).doc(dateNow)
        .get();

      mark = documentSnapshot.data()["timeIn"];
      out = documentSnapshot.data()["timeOut"];
      setState(() {
      });
      print("abeer");
      print(mark);


  }

  getDateTime() {
    DateTime now = DateTime.now();
    dateNow = "${now.year}-${now.month}-${now.day}";
    year = now.year.toString();
    month = now.month.toString();
    timeNow = "${now.hour}:${now.minute}";
  }


  calculateAttendancePercentage(int weekday, int attendance){
    if(weekday == 7){
      ++attendance;
      percentage = (attendance/now.day) * 100;
//      setState(() {
//
//      });
    } else {
      percentage = (attendance/now.day) * 100;
//      setState(() {
//      });
    }
  }




  @override
  void initState() {
    now = DateTime.now();
    dateNow = "${now.year}-${now.month}-${now.day}";
    year = now.year.toString();
    month = now.month.toString();
    timeNow = "${now.hour}:${now.minute}";
    getDailyAttendance();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     now = DateTime.now();
     dateNow = "${now.year}-${now.month}-${now.day}";
     year = now.year.toString();
     month = now.month.toString();
     timeNow = "${now.hour}:${now.minute}";
    getAttendance();
   // getDailyAttendance();


    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(FirebaseAuth.instance.currentUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.data.data()["approve"] == false){
          Map<String, dynamic> data = snapshot.data.data();
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              backgroundColor: Colors.greenAccent.shade400,
              title: Text(
                'Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
              endDrawer: new Drawer(
                child: new ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    new DrawerHeader(
                      decoration:
                      BoxDecoration(color: Colors.greenAccent.shade400),
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                        child: new Row(
                          children: [
                            new Container(
                              child: new CircleAvatar(
                                backgroundImage: new NetworkImage(
                                    'https://i.pravatar.cc/150?img=3'),
                                backgroundColor: Colors.white,
                                radius: 48.0,
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.only(left: 7.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text(
                                    '${data['name']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                  ),
                                  new Text(
                                    "ID: ${data['empId']}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    new ListTile(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(route: "users",),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.only(left: 40.0),
                      leading: new Container(
                        child: Icon(
                          Icons.person_outline_sharp,
                          size: 30.0,
                          color: Colors.greenAccent.shade400,
                        ),
                      ),
                      title: new Text(
                        'My Profile',
                        style: TextStyle(color: Colors.black, fontSize: 14.0),
                      ),
                    ),
                    new Divider(
                      color: Colors.greenAccent.shade400,
                      height: 3.0,
                    ),
//                  new ListTile(
//                    onTap: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (BuildContext context) {
//                            return AdminView();
//                          },
//                        ),
//                      );
//                    },
//                    contentPadding: EdgeInsets.only(left: 40.0),
//                    leading: new Container(
//                      child: Icon(
//                        Icons.admin_panel_settings_outlined,
//                        size: 35.0,
//                        color: Colors.greenAccent.shade400,
//                      ),
//                    ),
//                    title: new Text(
//                      'Admin Panel',
//                      style: TextStyle(color: Colors.black, fontSize: 14.0),
//                    ),
//                  ),
//                  new Divider(
//                    color: Colors.greenAccent.shade400,
//                    height: 3.0,
//                  ),
                    new ListTile(
                      onTap: () {
                        AuthProvider().userLogOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.only(left: 40.0),
                      leading: new Container(
                        child: Icon(
                          Icons.logout,
                          size: 30.0,
                          color: Colors.greenAccent.shade400,
                        ),
                      ),
                      title: new Text(
                        'Logout',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    new Divider(
                      color: Colors.greenAccent.shade400,
                      height: 3.0,
                    ),
                  ],
                ),
              ),
            body: Center(
              child: Text("Your Application is in review please wait"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done && snapshot.data.data()["approve"] == true) {
          Map<String, dynamic> data = snapshot.data.data();
          return new Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              backgroundColor: Colors.greenAccent.shade400,
              title: Text(
                'Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
            endDrawer: new Drawer(
              child: new ListView(
                padding: EdgeInsets.zero,
                children: [
                  new DrawerHeader(
                    decoration:
                        BoxDecoration(color: Colors.greenAccent.shade400),
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: new Row(
                        children: [
                          new Container(
                            child: new CircleAvatar(
                              backgroundImage: new NetworkImage(
                                  'https://i.pravatar.cc/150?img=3'),
                              backgroundColor: Colors.white,
                              radius: 48.0,
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(
                                  '${data['name']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                ),
                                new Text(
                                  "ID: ${data['empId']}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  new ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(route: "users",),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.only(left: 40.0),
                    leading: new Container(
                      child: Icon(
                        Icons.person_outline_sharp,
                        size: 30.0,
                        color: Colors.greenAccent.shade400,
                      ),
                    ),
                    title: new Text(
                      'My Profile',
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ),
                  new Divider(
                    color: Colors.greenAccent.shade400,
                    height: 3.0,
                  ),
//                  new ListTile(
//                    onTap: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (BuildContext context) {
//                            return AdminView();
//                          },
//                        ),
//                      );
//                    },
//                    contentPadding: EdgeInsets.only(left: 40.0),
//                    leading: new Container(
//                      child: Icon(
//                        Icons.admin_panel_settings_outlined,
//                        size: 35.0,
//                        color: Colors.greenAccent.shade400,
//                      ),
//                    ),
//                    title: new Text(
//                      'Admin Panel',
//                      style: TextStyle(color: Colors.black, fontSize: 14.0),
//                    ),
//                  ),
//                  new Divider(
//                    color: Colors.greenAccent.shade400,
//                    height: 3.0,
//                  ),
                  new ListTile(
                    onTap: () {
                      AuthProvider().userLogOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.only(left: 40.0),
                    leading: new Container(
                      child: Icon(
                        Icons.logout,
                        size: 30.0,
                        color: Colors.greenAccent.shade400,
                      ),
                    ),
                    title: new Text(
                      'Logout',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  new Divider(
                    color: Colors.greenAccent.shade400,
                    height: 3.0,
                  ),
                ],
              ),
            ),
            body: new Container(
              padding: EdgeInsets.all(10),
              child: new Column(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        new Card(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/lgucard.jpg"),
                                fit: BoxFit.fitWidth,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.7),
                                    BlendMode.srcOver),
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: new Row(
                              children: [
                                new Container(
                                  padding:
                                      EdgeInsets.fromLTRB(12.0, 40.0, 0.0, 40.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Text(
                                        'Your attandance is',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      new Text(
                                        percentage.toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 36.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  padding:
                                      EdgeInsets.fromLTRB(42.0, 40.0, 0.0, 40.0),
                                  child: new CircleAvatar(
                                    backgroundImage: new NetworkImage(
                                        'https://i.pravatar.cc/150?img=3'),
                                    backgroundColor: Colors.white,
                                    radius: 28.0,
                                  ),
                                ),
                                new Container(
                                  padding:
                                      EdgeInsets.fromLTRB(7.0, 40.0, 0.0, 40.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      new Text(
                                        '${data['name']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                      ),
                                      new Text(
                                        "ID: ${data['empId']}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      clipBehavior: Clip.none,
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if( mark == null) {
                              EasyGeofencing.startGeofenceService(
                                  pointedLatitude: "31.4640",
                                  pointedLongitude: "74.4426",
                                  radiusMeter: "250",
                                  eventPeriodInSeconds: 5);
                              if (geofenceStatusStream == null) {
                                geofenceStatusStream = EasyGeofencing.getGeofenceStream()
                                    .listen((GeofenceStatus status) {
                                  print(status.toString());
                                  if(status.toString() == "GeofenceStatus.exit"){
                                    print("Exit");
                                  } else {
                                    getDateTime();
                                    StorageProvider()
                                        .markAttendance(
                                        dateNow, timeNow, year, month)
                                        .then((value) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text("Attendance marked Successfully")));
                                    });
                                    getDailyAttendance();
                                  }
//                                  setState(() {
//                                    geofenceStatus = status.toString();
//                                  });
                                });
                              }

                            }
                              else {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Attendance already marked")));
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              color: mark ==null ? Colors.greenAccent.shade400 : Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                                child: Text(
                              "Time In",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            if( out == null || out == "00:00") {
                              EasyGeofencing.startGeofenceService(
                                  pointedLatitude: "31.4640",
                                  pointedLongitude: "74.4426",
                                  radiusMeter: "250",
                                  eventPeriodInSeconds: 5);
                              if (geofenceStatusStream == null) {
                                geofenceStatusStream = EasyGeofencing.getGeofenceStream()
                                    .listen((GeofenceStatus status) {
                                  print(status.toString());
                                  if(status.toString() == "GeofenceStatus.exit"){
                                    print("Exit");
                                  } else {
                                    getDateTime();
                                    StorageProvider()
                                        .markAttendance(
                                        dateNow, timeNow, year, month)
                                        .then((value) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text("Attendance marked Successfully")));
                                    });
                                    getDailyAttendance();
                                  }
//                                  setState(() {
//                                    geofenceStatus = status.toString();
//                                  });
                                });
                              }

                            }
                            else {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Attendance already marked")));
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              color: out ==null || out == "00:00" ? Colors.greenAccent.shade400 : Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                                child: Text(
                              "Time Out",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 34)),
                  new Container(
                    height: 70,
                    child: new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      elevation: 5,
                      // margin: EdgeInsets.all(10),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          new Text(
                            'Att.',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          new Text(
                            'In',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          new Text(
                            'Out',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: Container(
                      child: FutureBuilder(
                          future: getAttendance(),
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return snapshot.data.length == 0
                                  ? Container(
                                child: Center(
                                    child: Text(
                                      "No Record",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0),
                                    )),
                              )
                                  : ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index){
                                  print(FirebaseAuth.instance.currentUser.uid);
                                  print(snapshot.data[index].data()["date"]);
                                  Future.delayed(const Duration(milliseconds: 500), () {
                                    calculateAttendancePercentage(weekday, snapshot.data.length);
                                  });

                                return Container(
                                  height: 70,
                                  child: new Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Text(
                                          snapshot.data[index].data()["date"].toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green.shade400,
                                        ),
                                        new Text(
                                          snapshot.data[index].data()["timeIn"],
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        new Text(
                                          snapshot.data[index].data()["timeOut"] == null ? "00:00" : snapshot.data[index].data()["timeOut"],
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );},
                              );
                            }
                          }
                      ),
                    ),
                  ),



                  // Flexible(child: AttendanceCard()),

                  //  Card widget
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class AttendanceCard extends StatefulWidget {
  @override
  _AttendanceCardState createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  final Stream<QuerySnapshot> attendanceStream = FirebaseFirestore.instance
      .collection('users')
      .doc("")
      .collection("attendance")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: attendanceStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          );
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map data = document.data();
            new Container(
              height: 70,
              child: new Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Text(
                      "${data['date']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green.shade400,
                    ),
                    new Text(
                      '8:00am',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    new Text(
                      '4:00pm',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
