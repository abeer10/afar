import 'dart:math';

import 'package:afar/Providers/AuthProvider.dart';
import 'package:afar/Screens/User/staff_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';

class EmployeeRegistration extends StatefulWidget {
  @override
  _EmployeeRegistrationState createState() => _EmployeeRegistrationState();
}

class _EmployeeRegistrationState extends State<EmployeeRegistration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController empIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String imagePath = null;
  bool _showPassword = false;

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    _uploadImageToFirebase(image);

  }



  Future<void> _uploadImageToFirebase(File image) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = 'images/image${randomNumber}.jpg';

      // Upload image to firebase.
      final Reference storageReference = FirebaseStorage.instance.ref().child(imageLocation);
      final UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;
      final TaskSnapshot downloadUrl = (await uploadTask);
      imagePath = await downloadUrl.ref.getDownloadURL();
      print(imagePath);
      // await post();
      setState(() {
        imagePath = imagePath;
      });

    }catch(e){
      print(e.message);
    }
  }


  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Register Employee',
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
      ),
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
                padding: EdgeInsets.all(30.0),
                children: [
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imagePath != null ? InkWell(
                        child: CachedNetworkImage(
                          imageUrl: '$imagePath',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        onTap: (){
                          _imgFromGallery();
                        },
                      ) :  InkWell(
                          onTap: (){
                            _imgFromGallery();
                          },
                        child: Stack(
                          children: [
                            Container(
                              child: new CircleAvatar(
                                backgroundImage: new AssetImage(
                                    'images/avatar.png'),
                                backgroundColor: Colors.white,
                                radius: 60.0,
                              ),
                            ),
                            Positioned(
                              top: 70,
                              left: 80,
                              child: Container(
                                child: new CircleAvatar(
                                  backgroundImage: new AssetImage(
                                      'images/camera.png'),
                                  backgroundColor: Colors.white,
                                  radius: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Material(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        child: new TextField(
                          onEditingComplete: () => node.nextFocus(),
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'NAME',
                            hintText: 'Full Name',
                            fillColor: Colors.white,
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
                      SizedBox(
                        height: 20.0,
                      ),
                      Material(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        child: new TextField(
                          onEditingComplete: () => node.nextFocus(),
                          controller: empIdController,
                          decoration: InputDecoration(
                            labelText: 'EMPLOYEE ID',
                            hintText: '123456',
                            fillColor: Colors.white,
                            focusColor: Colors.greenAccent.shade400,
                            prefixIcon: Icon(
                              Icons.perm_identity_outlined,
                              color: Colors.greenAccent.shade400,
                            ),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Material(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        child: new TextField(
                          onEditingComplete: () => node.nextFocus(),
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'EMAIL',
                            hintText: 'example@gmail.com',
                            fillColor: Colors.white,
                            focusColor: Colors.greenAccent.shade400,
                            prefixIcon: Icon(
                              Icons.email_rounded,
                              color: Colors.greenAccent.shade400,
                            ),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Material(
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
                      SizedBox(
                        height: 20.0,
                      ),

                      SizedBox(
                        height: 40.0,
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
                          onPressed: () {
                            AuthProvider()
                                .createUser(
                              nameController.text.trim(),
                              empIdController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              imagePath== null ? "https://firebasestorage.googleapis.com/v0/b/afar-bda73.appspot.com/o/images%2Favatar-removebg-preview.png?alt=media&token=7f99d8ca-8e70-41d6-b448-0f52e80e47e0" : imagePath
                            )
                                .then((value) {
                              if (value == 'account created') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaffView(),
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("Account Created Successfully")));
                              } else {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text(value)));
                              }
                            });
                          },
                          child: new Text(
                            'Register',
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
                            'Already Registered?',
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            ),
                            child: new Text(
                              'Login',
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
