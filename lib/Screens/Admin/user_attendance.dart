import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAttendance extends StatefulWidget {
  Map data;
  UserAttendance({this.data});
  @override
  _UserAttendanceState createState() => _UserAttendanceState();
}

class _UserAttendanceState extends State<UserAttendance> {
  var year;
  String month;
  TextEditingController timeIn = TextEditingController();
  TextEditingController timeOut = TextEditingController();
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  Future getAttendance() async {

    QuerySnapshot querySnapshot = await user
        .doc(widget.data["uid"])
        .collection("attendance")
        .doc(year)
        .collection(month)
        .get();
    print(querySnapshot.docs.length);
    return querySnapshot.docs;
  }
@override
  void initState() {
  DateTime now = DateTime.now();
   year = now.year.toString();
   month = now.month.toString();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    print(widget.data);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("User Record", style: TextStyle(color: Colors.white),),
          leading: InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select Year", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("users").doc(widget.data["uid"]).collection("attendance")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return CircularProgressIndicator();
                    else {
                      List<DropdownMenuItem> organization = [];
                      for (int i = 0; i < snapshot.data.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data.docs[i];
                        organization.add(
                          DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0),
                              child: Text(
                                snap['year'],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            value: "${snap.id}",
                          ),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                        ),
                        child: DropdownButton(
                          style: TextStyle(color: Colors.black87),
                          underline: Container(
                            height: 0,
                          ),
                          icon: Icon(Icons.arrow_downward),
                          items: organization,
                          onChanged: (orgs) {
                            // final snackBar = SnackBar(
                            //   content: Text(
                            //     'Selected Organization value is a $orgs',
                            //     style: TextStyle(color: Colors.black),
                            //   ),
                            // );
                            // Scaffold.of(context).showSnackBar(snackBar);
                            setState(() {
                              // assign selected organizations
                              year = orgs;
                            });
                            print(year);
                          },
                          value: year,
                          isExpanded: true,
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              "Choose Year",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    }
                  }
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select Month", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
             Container(
               decoration: BoxDecoration(
                 border: Border.all(
                   color: Colors.green
                 )
               ),
               child: DropdownButton(
          hint: month == null
                ? Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Text('Select Month', style: TextStyle(color: Colors.black87, ),),
                )
                : Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Text(
            month,
                   style: TextStyle(color: Colors.black87),

          ),
                ),
          isExpanded: true,
       // iconSize: 30.0,
          style: TextStyle(color: Colors.black),
                 underline: Container(
                   height: 0,

                 ),
                 icon: Icon(Icons.arrow_downward),
          items: ['1', '2', '3','4', '5', '6','7', '8', '9','10', '11', '12'].map(
                  (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child: Text(val),
                  ),
                );
            },
          ).toList(),
          onChanged: (val) {
            setState(
                    () {
                  month= val;
                },
            );
          },
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
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 70,
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
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              timeIn.text = snapshot.data[index].data()["timeIn"];
                                              timeOut.text = snapshot.data[index].data()["timeOut"];
                                             showDialog(
                                               context: context,
                                               builder: (BuildContext context){
                                                 return AlertDialog(
                                                   title: Text("Edit Attendance"),
                                                   content: Container(
                                                     height: 300,
                                                     child: Column(
                                                       children: [
                                                         Text("Time In"),
                                                         SizedBox(height: 10,),
                                                         TextField(
                                                           controller: timeIn,
                                                           decoration: InputDecoration(
                                                             labelText: "Enter Time In",
                                                             fillColor: Colors.greenAccent,
                                                             focusedBorder:OutlineInputBorder(
                                                               borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                                               borderRadius: BorderRadius.circular(25.0),
                                                             ),
                                                           ),
                                                         ),
                                                         SizedBox(height: 20,),
                                                         Text("Time Out"),
                                                         SizedBox(height: 10,),
                                                         TextField(
                                                           controller: timeOut,
                                                           decoration: InputDecoration(
                                                             labelText: "Enter Time Out",
                                                             fillColor: Colors.greenAccent,
                                                             focusedBorder:OutlineInputBorder(
                                                               borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                                               borderRadius: BorderRadius.circular(25.0),
                                                             ),
                                                           ),
                                                         ),

                                                       ],
                                                     ),
                                                   ),
                                                   actions: [
                                                     FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel")),
                                                     FlatButton(onPressed: () async {
                                                       await FirebaseFirestore.instance.collection("users").doc(widget.data["uid"])
                                                           .collection("attendance").doc(year).collection(month).doc(snapshot.data[index].data()["date"]).
                                                           update({
                                                           "timeIn" : timeIn.text,
                                                           "timeOut" : timeOut.text
                                                       })
                                                           .then((value) {
                                                         Navigator.pop(context);
                                                         Scaffold.of(context).showSnackBar(
                                                             SnackBar(content: Text("User Attendance Updated Successfully")));
                                                         setState(() {
                                                         });
                                                       });

                                                       }, child: Text("Ok")),

                                                   ],
                                                 );
                                               }
                                             );

                                            },
                                            child: Container(
                                              height: 40,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.greenAccent.shade400,
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                    "Edit",
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
                                            onTap: () async {
                                              print(snapshot.data[index].data()["date"]);
                                             await FirebaseFirestore.instance.collection("users").doc(widget.data["uid"])
                                                 .collection("attendance").doc(year).collection(month).doc(snapshot.data[index].data()["date"]).delete()
                                             .then((value) {
                                               setState(() {
                                               });
                                               Scaffold.of(context).showSnackBar(
                                                   SnackBar(content: Text("User Attendance Deleted Successfully")));
                                             });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                    "Delete",
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
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              );},
                          );
                        }
                      }
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
