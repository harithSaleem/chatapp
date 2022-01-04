import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestor = FirebaseFirestore.instance;
late User signedInUser;

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  //give me email
  String? messageText; //this give me messages
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  // void getMessages() async {
  //   final messages = await _firestor.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }

  // void messagesStrem() async {
  //   await for (var snapshot in _firestor.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset(
              'assets/images/l.png',
              height: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'MessageMe',
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // messagesStrem();
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStremBulider(),
            // StreamBuilder<QuerySnapshot>(
            //   stream: _firestor.collection('messages').snapshots(),
            //   builder: (context, snapshot) {
            //     List<MessageLine> messageWidgets = [];

            //     if (!snapshot.hasData) {
            //       //add here spinner
            //       return const Center(
            //         child: CircularProgressIndicator(
            //           backgroundColor: Colors.blueAccent,
            //         ),
            //       );
            //     }

            //     final messages = snapshot.data!.docs;
            //     for (var message in messages) {
            //       final messageText = message.get('text');
            //       final messagesender = message.get('sender');
            //       final messageWidget = MessageLine(
            //         sender: messagesender,
            //         text: messageText,
            //       );
            //       messageWidgets.add(messageWidget);
            //     }
            //     return Expanded(
            //       child: ListView(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 10,
            //           vertical: 20,
            //         ),
            //         children: messageWidgets,
            //       ),
            //     );
            //   },
            // ),
            Container(
              decoration: const BoxDecoration(
                  // border: Border(
                  //   top: BorderSide(
                  //     color: Colors.orange,
                  //     width: 2.0,
                  //   ),
                  // ),
                  ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            hintText: 'write your message here...',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestor.collection('messages').add({
                        'text': messageText,
                        'sender': signedInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStremBulider extends StatelessWidget {
  const MessageStremBulider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestor.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];

        if (!snapshot.hasData) {
          //add here spinner
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }

        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('text');
          final messagesender = message.get('sender');
          final currentUser = signedInUser.email;
          // if (currentUser == messagesender) {}
          final messageWidget = MessageLine(
            sender: messagesender,
            text: messageText,
            isme: currentUser == messagesender,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({
    Key? key,
    required this.sender,
    required this.text,
    required this.isme,
  }) : super(key: key);

  final String? sender;
  final String? text;
  final bool isme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(color: Colors.yellow[900], fontSize: 12),
          ),
          Material(
            elevation: 5,
            borderRadius: isme
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isme ? Colors.blue[800] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15, color: isme ? Colors.white : Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
