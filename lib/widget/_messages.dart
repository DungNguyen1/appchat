import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.messages, this.username, this.userimage, this.isMe,
      {required this.key});

  final String username;
  final String userimage;
  final String messages;
  final bool isMe;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  )),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      messages,
                      style:
                          TextStyle(color: isMe ? Colors.black : Colors.black),
                    ),
                  ]),
            ),
          ]),
      Positioned(
          top: 18,
          left: isMe ? null : 148,
          right: isMe ? 148 : null,
          child: CircleAvatar(
            radius: 13,
            backgroundImage: NetworkImage(userimage),
          ))
    ]);
  }
}
