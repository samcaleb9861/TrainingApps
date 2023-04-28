import 'package:flutter/material.dart';
import 'package:todo_app/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Authentication'),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent,
        ),
        body: AuthForm());
  }
}
