import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    // access user info
    final user = FirebaseAuth.instance.currentUser!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signed in as',
            style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              user.email!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 40.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50.0),
              ),
              icon: Icon(Icons.arrow_back, size: 32.0), 
              label: Text(
                'SignOut',
                style: TextStyle(fontSize: 24.0),
              ),
              onPressed: () => FirebaseAuth.instance.signOut(), 
            ),
          ],
        ),
      ),
    );
  }
}