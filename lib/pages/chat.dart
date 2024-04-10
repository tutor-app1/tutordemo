import 'package:flutter/material.dart';
import 'dart:ui' as ui;
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
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<String> getOrCreateConversationId(String userId, String otherUserId, String lastMessage) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<String> ids = [userId, otherUserId];
    ids.sort(); // sort so they are always in the same order
    String conversationId = ids.join('-');

    final DocumentSnapshot docSnapshot = await _firestore.collection('conversations').doc(conversationId).get();

    if (!docSnapshot.exists) {
      // If the conversation doesn't exist, create it
      await _firestore.collection('conversations').doc(conversationId).set({
        'users': ids,
        'lastMessage': lastMessage,
        'timestamp': FieldValue.serverTimestamp(),
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

    // If the user is not found in either collection, return a default value
    return 'Unknown user';
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
      backgroundColor: FlutterFlowTheme.of(context).secondaryText,
      appBar: AppBar(
        //backgroundColor: FlutterFlowTheme.of(context).lineColor,
        title: Text('C h a t s',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: FlutterFlowTheme.of(context).secondary,
        ),),
        flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                                      FlutterFlowTheme.of(context).accent2,
                                      FlutterFlowTheme.of(context).accent4,
                                    ],
              ),
            ),
          ),
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
                      final lastMessage = messages[index].get('lastMessage') ?? '';

                      return FutureBuilder<String>(
                        future: getUsername(otherUserId),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show a loading spinner while waiting
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}'); // Show an error message if something went wrong
                          } else {
                            final username = snapshot.data ?? 'Unknown user'; // The username
                            return InkWell(
                              onTap: () async {
                                final conversationId = await getOrCreateConversationId(userId!, otherUserId, lastMessage);
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
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              child: ListTile(
                                title: Column (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text (
                                    username,
                                style: TextStyle(
                                  foreground: Paint()
                                  ..shader = ui.Gradient.linear(
                                    const Offset(0, 20),
                                    const Offset(150,20),
                                    <Color>[
                                      FlutterFlowTheme.of(context).accent2,
                                      FlutterFlowTheme.of(context).accent4,
                                    ],
                                    ),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  //color: FlutterFlowTheme.of(context).secondaryBackground,
                                ),
                              ), // Display the username
                              Text(
                                lastMessage, // The last message
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ), 
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                DateFormat('hh:mm a').format(message['timestamp'].toDate()), // The timestamp
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ), 
                            ),
                            ],
                            ),
                          ),
                        ),
                        );
                      }
                    },
                  );
                },
              );
                } else if (snapshot.hasError) {
                  //print('Error: ${snapshot.error}');
                  return Center(
                    child: Text('An error occurred ${snapshot.error}',
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