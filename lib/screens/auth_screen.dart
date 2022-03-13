import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatsapp/widget/auth_form.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  void _submitAuthForm(String email, String username, String password,
      File image, bool islogin, BuildContext context) async {
    UserCredential authresult;
    {
      try {
        setState(() {
          _isLoading = true;
        });
        if (islogin) {
          authresult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
        } else {
          authresult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

          final ref = FirebaseStorage.instance
              .ref()
              .child("user_image")
              .child(authresult.user!.uid + ".ipg");
          await ref.putFile(image);
          final url = await ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection("users")
              .doc(authresult.user!.uid)
              .set({"username": username, "email": email, "image_url": url});
        }
      } on PlatformException catch (err) {
        setState(() {
          _isLoading = false;
        });
        var message = "An error occurred, please check your credentials";
        if (err.message != null) {
          message = err.message!;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ));
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Authform(_submitAuthForm, _isLoading),
    );
  }
}
