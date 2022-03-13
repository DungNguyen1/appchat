import 'dart:ffi';
import 'dart:io';

import 'package:chatsapp/picker_image/pickeruser_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authform extends StatefulWidget {
  Authform(this.submitfn, this.isLoading);
  // ignore: non_constant_identifier_names
  final bool isLoading;
  void Function(
    String email,
    String user,
    String password,
    File image,
    bool islogin,
    BuildContext ctx,
  ) submitfn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<Authform> {
  final _fromkey = GlobalKey<FormState>();
  var _isLogin = true;
  String _email = '';
  String _user = '';
  String _password = '';
  var _userimage;
  void _pickedImage(File image) {
    _userimage = image;
  }

  void _trysubmit() {
    final isValid = _fromkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userimage == null && !_isLogin) {
      Scaffold.of(context).showBottomSheet((ctx) => GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.blue),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.teal,
                  ),
                  height: 40,
                  width: 350,
                  child: Text(
                    "Please pick an image",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ));
      return;
    }
    if (isValid) {
      _fromkey.currentState!.save();
      widget.submitfn(_email.trim(), _user.trim(), _password.trim(), _userimage,
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                  key: _fromkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin) Userimagepicker(_pickedImage),
                      TextFormField(
                        autocorrect: false,
                        key: ValueKey("Email"),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (String? value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "Please enter a valid email address.";
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _email = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: "Email address"),
                      ),
                      if (!_isLogin)
                        TextFormField(
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          key: ValueKey("User"),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return "Please enter at least 4 characters.";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _user = value!;
                          },
                          decoration: InputDecoration(labelText: "Username"),
                        ),
                      TextFormField(
                        autocorrect: false,
                        key: ValueKey("Password"),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "Please enter at least 7 characters.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        decoration: InputDecoration(labelText: "Password"),
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        ElevatedButton(
                          onPressed: _trysubmit,
                          child: Text(_isLogin ? "Login" : "Signup"),
                        ),
                      if (!widget.isLoading)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              !widget.isLoading;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? "Create new account"
                                : 'I already have an account',
                          ),
                        )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
