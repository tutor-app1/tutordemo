import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:tutorapptrials/pages/chat_model.dart';

class ChatScreenWidget extends StatefulWidget {

  final String otherUserId;
  final String conversationId;

  const ChatScreenWidget({required Key key, required this.otherUserId, required this.conversationId}) : super(key: key);

  @override
  State<ChatScreenWidget> createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {

  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser!;
  
  String userName = '';
  String? tutorId;
  late String conversationId;

  
  void _sendMessage(String otherUserId, String message) async {
    final user = _auth.currentUser;
    if (user != null) {
      final String reciever = otherUserId;
      final timestamp = Timestamp.now();
      final message = _messageController.text;

      if (message.isNotEmpty) {
        await Message(sender: user.uid, reciever: reciever, message: message, timestamp: timestamp).sendMessage();
        _messageController.clear();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    conversationId = widget.conversationId;
  }

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      tutorId = arguments['tutorId'];
    }
  }

  Future<String> fetchUserName(String? tutorId) async {
    String userName = '';
    final DocumentSnapshot userSnapshot = await _firestore.collection('tutor').doc(tutorId).get();

    if (userSnapshot.exists && (userSnapshot.data() as Map).containsKey('username')) {
      userName = userSnapshot['username'];
    } else {
      final DocumentSnapshot studentSnapshot = await _firestore.collection('student').doc(tutorId).get();
      if (studentSnapshot.exists && (studentSnapshot.data() as Map).containsKey('username')) {
        userName = studentSnapshot['username'];
      }
    }
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
    future: fetchUserName(tutorId), // pass the tutorId here
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text(userName),
        ),
        body: Column(
          children: [
            Expanded(
              child: conversationId.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('messages').doc(conversationId).collection('chats').orderBy('timestamp', descending: false).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final messages = snapshot.data!.docs.map((doc) => doc.data()).toList();
                        if (messages.isEmpty) {
                          return Center(
                            child: Text(
                              'No messages',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).secondary,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final messageText = (message as Map?)?['message'] as String?;
                            final senderId = message?['sender'] as String?;
                            final isCurrentUser = senderId == user.uid;

                            //print('Message text: $messageText');
                            //print('Sender ID: $senderId');

                            return Align(
                              alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: isCurrentUser ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  messageText ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                            /*return ListTile(
                              title: Text(messageText.toString()),
                            );*/
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'An error occurred',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).secondary,
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(widget.otherUserId, _messageController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      }
    );
  }
}