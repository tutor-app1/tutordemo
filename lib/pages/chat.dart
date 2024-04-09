import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:tutorapptrials/pages/chat_screen.dart';
import 'package:tutorapptrials/pages/chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatModel _chatModel = ChatModel();
  User? user = FirebaseAuth.instance.currentUser;
  String? userId = FirebaseAuth.instance.currentUser!.uid;

  Future<String> getOrCreateConversationId(String userId, String otherUserId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<String> ids = [userId, otherUserId];
    ids.sort(); // sort so they are always in the same order
    String conversationId = ids.join('-');

    final DocumentSnapshot docSnapshot = await _firestore.collection('conversations').doc(conversationId).get();

    if (!docSnapshot.exists) {
      // If the conversation doesn't exist, create it
      await _firestore.collection('conversations').doc(conversationId).set({
        'users': ids,
        // Add any other fields you need for a conversation
      });
    }

    return conversationId;
  }

  Future<String> getUsername(String userId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot userDoc;

  // Try to get the user from the 'tutor' collection
  userDoc = await _firestore.collection('tutor').doc(userId).get();
  if (userDoc.exists) {
    return userDoc['username'];
  }

  // If the user is not found in the 'tutor' collection, try the 'student' collection
  userDoc = await _firestore.collection('student').doc(userId).get();
  if (userDoc.exists) {
    return userDoc['username'];
  }

  // If the user is not found in either collection, throw an error or return a default value
  throw Exception('User not found');
}

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
                  print('Messages: $messages');

                  if (messages.isEmpty) {
                    return Center(
                      child: Text('No messages',
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
                      final users = List<String>.from(message['users']);
                      final otherUserId = users.firstWhere((id) => id != userId);

                      return FutureBuilder<String>(
                        future: getUsername(otherUserId),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show a loading spinner while waiting
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}'); // Show an error message if something went wrong
                          } else {
                            final username = snapshot.data; // The username
                            return InkWell(
                              onTap: () async {
                                final conversationId = await getOrCreateConversationId(userId!, otherUserId);
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
                                title: Text(username!), // Display the username
                              ),
                            );
                          }
                        },
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
        ],
      ),
    );
  }
}