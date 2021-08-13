import 'package:afar/Screens/User/employeeRegistration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/User/login.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Afar());
}

class Afar extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AfarState createState() => _AfarState();
}

class _AfarState extends State<Afar> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "AFAR - Facial Attendance Reader",
            home: new Login(),
            theme: ThemeData(
              primaryColor: Colors.greenAccent.shade400,
              // fontFamily: 'Raleway',
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
