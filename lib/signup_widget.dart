import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_auth/main.dart';
import 'package:login_auth/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget{
  final Function() onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget>{
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(16.0),
    child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 60.0),
          FlutterLogo(size: 120.0),
          SizedBox(height: 20.0),
          Text(
            'Hey There, \n Welcome Back',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
          // email field
          SizedBox(height: 40.0),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Enter email'),
            // validates email format
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) => 
              email != null && !EmailValidator.validate(email)
                ? 'Enter a valid email'
                : null,
          ),
          // password field
          SizedBox(height: 4.0),
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Password required'),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => 
              value != null && value.length < 6
                ? 'Enter min. 6 characters'
                : null,
          ),
          // button
          SizedBox(height: 20.0),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50.0),
            ),
            icon: Icon(Icons.arrow_forward, size: 32.0), 
            label: Text(
              'Sign Up',
              style: TextStyle(fontSize: 24.0),
            ),
            onPressed: signUp, 
          ),
          SizedBox(height: 20.0),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white),
              text: 'Already have an account? ',
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignIn,
                  text: 'Log In',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                )
              ]
            ))
        ],
      )),
  );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );
    // catch error
    } on FirebaseAuthException catch (e){
      print(e);

      // if email is already signed up
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);  

  }
}