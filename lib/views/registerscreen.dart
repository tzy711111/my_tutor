import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tutor/views/loginscreen.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/images/userprofile.png';
  var _image;
  bool _passwordVisible = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneNumEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _addressEditingController =
      TextEditingController();

  @override
  void dispose() {
    print("dispose was called");
    _nameEditingController.dispose();
    _phoneNumEditingController.dispose();
    _emailEditingController.dispose();
    _addressEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth / 0.5;
    }
    return Scaffold(
      body: Stack(
        children: [upHalf(context), lowHalf(context)],
      ),
    );
  }

  upHalf(BuildContext context) {
    return SizedBox(
      height: screenHeight / 2.5,
      width: ctrwidth,
      child: Image.asset('assets/images/logincover.jpeg', fit: BoxFit.cover),
    );
  }

  lowHalf(BuildContext context) {
    return Container(
      height: screenHeight,
      width: ctrwidth,
      margin: EdgeInsets.only(top: screenHeight / 17),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                elevation: 40,
                child: Form(
                    key: _formKey,
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                        child: Column(children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Register New Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          const SizedBox(height: 10),
                          Stack(children: [
                            SizedBox(
                                height: 130,
                                width: 130,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: GestureDetector(
                                        onTap: () => {_takePictureDialog()},
                                        child: _image == null
                                            ? Image.asset(pathAsset)
                                            : Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                              )))),
                          ]),
                          TextFormField(
                            controller: _emailEditingController,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                icon: const Icon(Icons.email),
                                alignLabelWithHint: true,
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid email';
                              }
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);
                              if (!emailValid) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _nameEditingController,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.person),
                                labelText: 'Name',
                                alignLabelWithHint: true,
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _phoneNumEditingController,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.phone),
                                labelText: 'Phone Number',
                                alignLabelWithHint: true,
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }

                              bool phoneValid =
                                  RegExp(r'(^[0-9]*$)').hasMatch(value);
                              if (!phoneValid) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _addressEditingController,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.home),
                                labelText: 'Home Address',
                                alignLabelWithHint: true,
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter home address';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordEditingController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                icon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                alignLabelWithHint: true,
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password.';
                              }

                              if (value.length < 6) {
                                return 'Six characters minimum.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 300,
                              height: 35,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0))),
                                  child: const Text("Register"),
                                  onPressed: () {
                                    _confirmation();
                                  }),
                            ),
                          ),
                        ])))),
            const SizedBox(height: 15),
            Row(
              children: <Widget>[
                const SizedBox(width: 65),
                const Text("Already register?",
                    style: TextStyle(
                      fontSize: 14.0,
                    )),
                GestureDetector(
                  onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen()))
                  },
                  child: const Text(
                    " Sign in!",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _confirmation() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register new account?",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _registerNewUser();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Please complete the registration form.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  void _registerNewUser() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _email = _emailEditingController.text;
    String _name = _nameEditingController.text;
    String _phoneNum = _phoneNumEditingController.text;
    String _password = _passwordEditingController.text;
    String _address = _addressEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/register_user.php"),
        body: {
          "email": _email,
          "name": _name,
          "phoneNum": _phoneNum,
          "password": _password,
          "address": _address,
          "image": base64Image,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => const LoginScreen()));
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
