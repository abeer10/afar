import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  String route;
  Profile({this.route});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var user;

  getUser()async {
    print(widget.route);
    user =  await FirebaseFirestore.instance.collection(widget.route).doc(FirebaseAuth.instance.currentUser.uid).get();
    //print(user["email"]);
    setState(() {
    });
  }

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white,)),

      ),
      body: user == null ? Center(child: CircularProgressIndicator()) : Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
             image: AssetImage("images/lgucard.jpg"),
          fit: BoxFit.fitHeight,
          colorFilter: ColorFilter.mode(
              Colors.blueGrey.shade900.withOpacity(0.7),
              BlendMode.srcOver),
          alignment: Alignment.topCenter,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Container(
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(
                    'https://i.pravatar.cc/150?img=3'),
                backgroundColor: Colors.white,
                radius: 60.0,
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person, color: Colors.greenAccent.shade400, size: 30,),
                    ),

                    Text(user["name"], style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.email, color: Colors.greenAccent.shade400, size: 30,),
                    ),

                    Text(user["email"], style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),)
                  ],
                ),
              ),
),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.perm_identity_rounded, color: Colors.greenAccent.shade400, size: 30,),
                    ),
                  widget.route != "admin" ?  Text(user["empId"], style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),)
                  : Text("0000", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),)
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
