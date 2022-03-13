import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NewMesseges extends StatefulWidget {
  const NewMesseges({Key? key}) : super(key: key);

  @override
  _NewMessegesState createState() => _NewMessegesState();
}

class _NewMessegesState extends State<NewMesseges> {
  var enteredMesseges = '';
  final _controler = TextEditingController();

  void sendMesseges() async {
    late final Map<String, dynamic> user_data;
    final _user = await FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_user!.uid)
        .get()
        .then((value) => {user_data = value.data()!});

    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection("chats").add({
      'text': enteredMesseges,
      'createdAt': Timestamp.now(),
      'userId': _user.uid,
      'name': user_data['username'],
      'userImage': user_data['image_url'],
    });
    _controler.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
            child: TextField(
          autocorrect: false,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(textBaseline: TextBaseline.alphabetic),
          controller: _controler,
          decoration: InputDecoration(labelText: "Send a messeges..."),
          onChanged: (value) {
            setState(() {
              enteredMesseges = value;
            });
          },
        )),
        IconButton(
          color: Theme.of(context).primaryColor,
          onPressed: enteredMesseges.trim().isEmpty ? null : sendMesseges,
          icon: Icon(Icons.send),
        )
      ]),
    );
  }
}
