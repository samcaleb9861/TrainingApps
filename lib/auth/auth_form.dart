import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form_key = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;
//=========================
  startauthentication() {
    final validity = _form_key.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _form_key.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    AuthResult authResult;
    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user.uid;
        await Firestore.instance
            .collection('users')
            .document(uid)
            .setData({'username': username, 'email': email});
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            height: 200,
            child: Image.asset('assets/images/icon.png'),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
              key: _form_key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: const ValueKey('username'),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Incorrect username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value ?? '';
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide()),
                          labelText: "Enter Username",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    validator: (String? value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value ?? '';
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide()),
                        labelText: "Enter the Email",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    key: const ValueKey('password'),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Incorrect Password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value ?? '';
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide()),
                        labelText: "Enter Password",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    height: 70,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        startauthentication();
                      },
                      child: isLoginPage
                          ? Text(
                              'Login',
                              style: GoogleFonts.roboto(fontSize: 16),
                            )
                          : Text(
                              'Sign up',
                              style: GoogleFonts.roboto(fontSize: 16),
                            ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginPage = !isLoginPage;
                          });
                        },
                        child: isLoginPage
                            ? Text(
                                'Not a member',
                                style: GoogleFonts.roboto(
                                    fontSize: 16, color: Colors.white),
                              )
                            : Text(
                                'Already a member?',
                                style: GoogleFonts.roboto(
                                    fontSize: 16, color: Colors.white),
                              )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
