import 'package:afar/Providers/AuthProvider.dart';
import 'package:afar/Providers/StorageProvider.dart';
import 'package:afar/Screens/Admin/user_attendance.dart';
import 'package:afar/Screens/User/employeeRegistration.dart';
import 'package:afar/Screens/User/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../profile.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  var user;
  // StorageProvider storageProvider;
  Future getUser() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    return querySnapshot.docs;
  }

  getAdmin()async {

    user =  await FirebaseFirestore.instance.collection("admin").doc(FirebaseAuth.instance.currentUser.uid).get();
   // print(user["email"]);
    setState(() {

    });

  }

  @override
  void initState() {
    getAdmin();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Admin Dashoard',
          style: TextStyle(fontSize: 24.0, color: Colors.white),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Container(
                      child: new CircleAvatar(
                        backgroundImage: new NetworkImage(
                            'https://i.pravatar.cc/150?img=3'),
                        backgroundColor: Colors.white,
                        radius: 48.0,
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
                    builder: (context) => Profile(route: "admin",),
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
      body: user == null ? Center(child: CircularProgressIndicator()) :  Column(
        // padding: EdgeInsets.all(7.0),
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/lgucard.jpg"),
                  fit: BoxFit.fitWidth,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.srcOver),
                  alignment: Alignment.topCenter,
                ),
              ),
              child: new Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(30.0),
                child: new Text(
                  'Employees',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          //  Text("abeer"),

          Expanded(
            flex: 3,
            child: Container(
              child: FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return snapshot.data.length == 0
                        ? Container(
                            child: Center(
                                child: Text(
                              "No User Registered",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            )),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: (){
                                  print(snapshot.data[index].data());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return UserAttendance(data: snapshot.data[index].data(),);
                                  },
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: new CircleAvatar(
                                          backgroundImage: new NetworkImage(
                                              'https://i.pravatar.cc/150?img=3'),
                                          backgroundColor: Colors.greenAccent.shade400,
                                          radius: 28.0,
                                        ),
                                        title: new Text(
                                          snapshot.data[index].data()["name"],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        subtitle: new Text(snapshot.data[index].data()["email"],),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red,),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).
                                            delete().then((value){

                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(content: Text("User Deleted Successfully")));
                                              setState(() {

                                              });
                                            });
                                          },
                                        )
                                      ),
                                      snapshot.data[index].data()["approve"] == false ? InkWell(

                                        child: Container(
                                          child: Center(child: Text("Approve")),
                                          height: 40,
                                          color: Colors.greenAccent.shade400,
                                        ),
                                        onTap: () async {
                                          print(FirebaseAuth.instance.currentUser.uid);
                                          await FirebaseFirestore.instance.collection("users").doc(snapshot.data[index].data()["uid"]).
                                          update({"approve" : true}).then((value){

                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(content: Text("User Approved Successfully")));
                                            setState(() {

                                            });
                                          });
                                        },
                                      ) : Container(),
                                  new Divider(
                                    color: Colors.black,
                                        height: 3.0,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                                         });
                  }
                },
              ),
            ),
          ),
//            new Padding(padding: EdgeInsets.all(15.0)),
//            new ListTile(
//              leading: new CircleAvatar(
//                backgroundImage:
//                    new NetworkImage('https://i.pravatar.cc/150?img=3'),
//                backgroundColor: Colors.greenAccent.shade400,
//                radius: 28.0,
//              ),
//              title: new Text(
//                'Employee Name',
//                style: TextStyle(color: Colors.black),
//              ),
//              subtitle: new Text('Professor'),
//              trailing: new Text(
//                '89%',
//                style: TextStyle(
//                  color: Colors.black,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 22.0,
//                ),
//              ),
//            ),
//            new Divider(
//              color: Colors.black,
//              height: 3.0,
//            ),
//            new ListTile(
//              leading: new CircleAvatar(
//                backgroundImage:
//                    new NetworkImage('https://i.pravatar.cc/150?img=3'),
//                backgroundColor: Colors.greenAccent.shade400,
//                radius: 28.0,
//              ),
//              title: new Text(
//                'Employee Name',
//                style: TextStyle(color: Colors.black),
//              ),
//              subtitle: new Text('Professor'),
//            ),
//            new Divider(
//              color: Colors.black,
//              height: 3.0,
//            ),
//            new ListTile(
//              leading: new CircleAvatar(
//                backgroundImage:
//                    new NetworkImage('https://i.pravatar.cc/150?img=3'),
//                backgroundColor: Colors.greenAccent.shade400,
//                radius: 28.0,
//              ),
//              title: new Text(
//                'Employee Name',
//                style: TextStyle(color: Colors.black),
//              ),
//              subtitle: new Text('Professor'),
//            ),
//            new Divider(
//              color: Colors.black,
//              height: 3.0,
//            ),
        ],
      ),
    );
  }
}
