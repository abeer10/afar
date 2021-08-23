import 'package:afar/Providers/AuthProvider.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
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
                  print(response.toString());
                  print("abeer");
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
