// ignore_for_file: use_key_in_widget_constructors

import 'package:chat_app/Screens/register.dart';
import 'package:chat_app/Screens/signin_screen.dart';
import 'package:chat_app/widgets/my_buttons.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  margin: const EdgeInsets.all(2.0),
                  child: Image.asset('assets/images/R.png'),
                ),
                const Text(
                  'MessageMe',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff2e386b),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(
              color: Colors.yellow[900]!,
              titel: 'Sign in',
              onpressed: () {
                Navigator.pushNamed(context, SignInScreen.screenRoute);
              },
            ),
            MyButton(
              color: Colors.blue[800]!,
              titel: 'Register',
              onpressed: () {
                Navigator.pushNamed(context, RegisterScreen.screenRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
