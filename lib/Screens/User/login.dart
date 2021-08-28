import 'package:afar/Providers/AuthProvider.dart';
import 'package:afar/Screens/Admin/admin_view.dart';
import 'package:afar/Screens/User/employeeRegistration.dart';
import 'package:afar/Screens/User/forgot_password.dart';
import 'package:afar/Screens/User/staff_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  TextEditingController emailController = TextEditingController(text: 'ali@gmail.com');
  TextEditingController passwordController = TextEditingController(text: '12345678');

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return new Scaffold(
      body: new Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/lgucard.jpg"),
                  fit: BoxFit.fitHeight,
                  colorFilter: ColorFilter.mode(
                      Colors.blueGrey.shade900.withOpacity(0.7),
                      BlendMode.srcOver),
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Positioned.fill(
              child: ListView(
                padding: EdgeInsets.fromLTRB(45.0, 45.0, 45.0, 0.0),
                children: [
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Icon(
                        Icons.person_outline_rounded,
                        size: 130.0,
                        color: Colors.greenAccent.shade400,
                      ),
                      new Text(
                        'AFAR',
                        style: new TextStyle(
                            fontSize: 48.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                      ),
                      new Text(
                        'Sign in',
                        style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2.0),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      new Material(
                        elevation: 15.0,
                        shadowColor: Colors.grey,
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        child: new TextField(
                          controller: emailController,
                          onEditingComplete: () => node.nextFocus(),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'example@gmail.com',
                            focusColor: Colors.greenAccent.shade400,
                            prefixIcon: Icon(
                              Icons.person_rounded,
                              color: Colors.greenAccent.shade400,
                            ),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      new Material(
                        elevation: 15.0,
                        shadowColor: Colors.grey,
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        child: Stack(
                          children: [
                            new TextField(
                              controller: passwordController,
                              obscureText: !this._showPassword,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: '**********',
                                prefixIcon: Icon(
                                  Icons.lock_rounded,
                                  color: Colors.greenAccent.shade400,
                                ),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye_rounded,
                                    color: this._showPassword
                                        ? Colors.greenAccent.shade400
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() => this._showPassword =
                                        !this._showPassword);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ),
                          );
                        },
                        child: new Text(
                          'Forgot your password? Recover',
                          style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      new Material(
                        elevation: 15.0,
                        shadowColor: Colors.grey,
                        color: Colors.greenAccent.shade400,
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        child: MaterialButton(
                          minWidth: 200.0,
                          onPressed: ()  {
                            AuthProvider()
                                .userSignIn(emailController.text.trim(), passwordController.text.trim(),
                            )
                                .then(
                              (value) async{
                                if (value == "Welcome")  {
                                  print(FirebaseAuth.instance.currentUser.uid);
                                 var user =  await FirebaseFirestore.instance.collection("admin").doc(FirebaseAuth.instance.currentUser.uid).get();
                                  if(user.exists){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminView(),
                                    ),
                                  );
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "$value ${FirebaseAuth.instance.currentUser.email}")));
                                 } else {
                                   Navigator.pushReplacement(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => StaffView(),
                                     ),
                                   );
                                 }
                                } else {
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('$value')));
                                }
                              },
                            );
                          },
                          child: new Text(
                            'Login',
                            style: new TextStyle(
                                color: Colors.white, fontSize: 22.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Text(
                            "Don't have an account?",
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeRegistration(),
                              ),
                            ),
                            child: new Text(
                              "Register",
                              style: new TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.greenAccent.shade400,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
