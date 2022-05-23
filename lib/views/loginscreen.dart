import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_tutor/views/registerscreen.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/regis.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  final _formKey = GlobalKey<FormState>();
  bool remember = false;
  bool _passwordVisible = true;

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }
    return Scaffold(
      body: Stack(
        children: [upperHalf(context), lowerHalf(context)],
      ),
    );
  }

  upperHalf(BuildContext context) {
    return SizedBox(
      height: screenHeight / 2.5,
      width: screenWidth,
      child: Image.asset('assets/images/logincover.jpeg', fit: BoxFit.cover),
    );
  }

  lowerHalf(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: ctrwidth,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 160, 20, 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                          child: SizedBox(
                              height: screenHeight / 1.8,
                              width: screenWidth,
                              child: SizedBox(
                                  height: screenHeight / 2.0,
                                  width: screenWidth,
                                  child: Column(children: [
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Sign In",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: 250,
                                      child: TextFormField(
                                        controller: _emailEditingController,
                                        decoration: InputDecoration(
                                            icon: const Icon(Icons.email),
                                            labelText: 'Email',
                                            alignLabelWithHint: true,
                                            border: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
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
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 250,
                                      child: TextFormField(
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
                                                  _passwordVisible =
                                                      !_passwordVisible;
                                                });
                                              },
                                            ),
                                            alignLabelWithHint: true,
                                            border: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
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
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: 0.9,
                                          child: Checkbox(
                                            value: remember,
                                            onChanged: (bool? value) {
                                              _onRememberMeChanged(value!);
                                            },
                                          ),
                                        ),
                                        const Text(
                                          "Remember Me",
                                          style: TextStyle(fontSize: 13.5),
                                        ),
                                        const SizedBox(width: 25),
                                        Container(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            width: 90,
                                            height: 35,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0))),
                                                child: const Text("Login"),
                                                onPressed: _loginUser),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ])))),
                      const SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 55),
                          const Text("No account?",
                              style: TextStyle(
                                fontSize: 14.0,
                              )),
                          GestureDetector(
                            onTap: () => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const RegisterScreen()))
                            },
                            child: const Text(
                              " Create one!",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          )
                        ],
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String email = _emailEditingController.text;
      String password = _passwordEditingController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('remember', true);
        Fluttertoast.showToast(
            msg: "Preference Stored",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        await prefs.setString('email', '');
        await prefs.setString('pass', '');
        await prefs.setBool('remember', false);
        _emailEditingController.text = "";
        _passwordEditingController.text = "";
        Fluttertoast.showToast(
            msg: "Preference Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Preference Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      remember = false;
    }
  }

  void _onRememberMeChanged(bool value) {
    remember = value;
    setState(() {
      if (remember) {
        _saveRemovePref(true);
      } else {
        _saveRemovePref(false);
      }
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        _emailEditingController.text = email;
        _passwordEditingController.text = password;
        remember = true;
      });
    }
  }

  void _loginUser() {
    String _email = _emailEditingController.text;
    String _password = _passwordEditingController.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/login_user.php"),
          body: {"email": _email, "password": _password}).then((response) {
        var data = jsonDecode(response.body);
        //print(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Registration regis = Registration.fromJson(data['data']);

          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        } 
        else {
          Fluttertoast.showToast(
              msg: "Login Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      });
    }
  }
}
