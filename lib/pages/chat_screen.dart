import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:tutorapptrials/pages/chat_model.dart';

class ChatScreenWidget extends StatefulWidget {

  final String otherUserId;
  final String conversationId;
  final String tutorId;

  const ChatScreenWidget({required Key key, required this.otherUserId, required this.conversationId, required this.tutorId}) : super(key: key);

  @override
  State<ChatScreenWidget> createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser!;
  
  String userName = '';
  String? tutorId;
  late String conversationId;
  Future<String>? userNameFuture;

  
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
    tutorId = widget.tutorId; // Retrieve tutorId from the widget
    //print('Tutor ID: $tutorId'); // Print the tutorId
    userNameFuture = fetchUserName(tutorId);
    _focusNode.requestFocus();
  }

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, String>? arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    if (arguments != null) {
      tutorId = arguments['tutorId'];
      //print('Tutor ID: $tutorId'); // Print the tutorId
      userNameFuture = fetchUserName(tutorId);
    }
  }

  Future<String> fetchUserName(String? tutorId) async {
    //print('Tutor ID: $tutorId');
    String userName = '';
    final DocumentSnapshot userSnapshot = await _firestore.collection('tutor').doc(tutorId).get();
    //print('Tutor document: ${userSnapshot.data()}');

    if (userSnapshot.exists && (userSnapshot.data() as Map).containsKey('username')) {
      userName = userSnapshot['username'];
    } else {
      final DocumentSnapshot studentSnapshot = await _firestore.collection('student').doc(tutorId).get();
      if (studentSnapshot.exists && (studentSnapshot.data() as Map).containsKey('username')) {
        userName = studentSnapshot['username'];
      }
    }
    //print('Fetched username: $userName');
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
    future: fetchUserName(tutorId), // pass the tutorId here
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data ?? 'C h a t M e s s a g e s'),
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

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
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
                                    ),
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
                      focusNode: _focusNode,
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

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}