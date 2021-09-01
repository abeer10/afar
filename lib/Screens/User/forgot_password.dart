import 'package:afar/Providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login.dart';

class ForgotPassword extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password", style: TextStyle(color: Colors.white),),
        leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Material(
              elevation: 15.0,
              shadowColor: Colors.grey,
              borderRadius: const BorderRadius.all(
                const Radius.circular(30.0),
              ),
              child: new TextField(
                controller: emailController,
               // onEditingComplete: () => node.nextFocus(),
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
            SizedBox(height: 20,),
            Material(
              elevation: 15.0,
              shadowColor: Colors.grey,
              color: Colors.greenAccent.shade400,
              borderRadius: const BorderRadius.all(
                const Radius.circular(30.0),
              ),
              child: MaterialButton(
                minWidth: 200.0,
                onPressed: () async {
                  var response = await AuthProvider().resetPassword(emailController.text.toString().trim());
                  if(response == null) {
                    Get.snackbar(
                        "This email didn't exist", "", snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red);
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          Login()), (Route<dynamic> route) => false);
                    });
                  } else{
                    Get.snackbar(
                        "Instructions sent to your email", "", snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green);
                  }
                  Future.delayed(const Duration(milliseconds: 3000), () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        Login()), (Route<dynamic> route) => false);
                  });

                  },
                child: new Text(
                  'Send',
                  style: new TextStyle(
                      color: Colors.white, fontSize: 22.0),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
