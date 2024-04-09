import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:tutorapptrials/pages/chat_screen.dart';
import 'package:tutorapptrials/pages/chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatModel _chatModel = ChatModel();
  User? user = FirebaseAuth.instance.currentUser;
  String? userId = FirebaseAuth.instance.currentUser!.uid;


  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      userId = user!.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatModel.getConversations(userId!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  if (messages.isEmpty) {
                    return Center(
                      child: Text('No messages',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).secondary,),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final messageText = message['message'];
                      final otherUserId = message['otherUserId']; // Replace with the actual field name
                      final conversationId = message['conversationId']; // Replace with the actual field name
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreenWidget(
                                key: const ValueKey('chat_screen'),
                                otherUserId: otherUserId,
                                conversationId: conversationId,
                                tutorId: otherUserId,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(messageText),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(
                    child: Text('An error occurred',
                    style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).secondary,)),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}