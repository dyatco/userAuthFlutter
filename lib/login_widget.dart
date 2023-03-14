import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_auth/forgot_password_page.dart';
import 'package:login_auth/main.dart';
import 'package:login_auth/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget{
  final VoidCallback onClickedSignUp;
  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Sign in text fields
        SizedBox(height: 40.0),
        TextField(
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: 'Enter email'),
        ),
        SizedBox(height: 4.0,),
        TextField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: 'Password required'),
          obscureText: true,
        ),

        // Button
        SizedBox(height: 20.0),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50.0)),
          icon: Icon(Icons.lock_open, size: 32.0), 
          label: Text('Sign In', style: TextStyle(fontSize: 24.0)),
          onPressed: signIn, 
        ),

        // Forgot password
        SizedBox(height: 24.0),
        GestureDetector(
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20,
            ),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ForgotPasswordPage(),
          )),
        ),

        // Sign up link
        SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.white),
            text: 'No account? ',
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignUp,
                text: 'Sign Up',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.secondary
                ),
              )
            ]
          )
        )
      ],
    ),
  );
  Future signIn() async{
    // show loading indicator
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );
    // catch error
    } on FirebaseAuthException catch (e){
      print(e);

      // if email does not exist
      Utils.showSnackBar(e.message);
    }

    // hides loading indicator when done
    navigatorKey.currentState!.popUntil((route) => route.isFirst);  
  }
}