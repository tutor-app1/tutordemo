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
  FocusNode myFocusNode = FocusNode(); 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser!;
  final ScrollController _scrollController = ScrollController();
  
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

    scrollDown();
    
  }

  void scrollDown() {
    final ScrollController _scrollController = ScrollController();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    conversationId = widget.conversationId;
    tutorId = widget.tutorId; // Retrieve tutorId from the widget
    //print('Tutor ID: $tutorId'); // Print the tutorId
    userNameFuture = fetchUserName(tutorId);
    myFocusNode.requestFocus();

    myFocusNode.addListener(() {
    if (myFocusNode.hasFocus) {
      Future.delayed(
        const Duration(milliseconds: 500), () {
        _scrollToBottom();
      });
      _scrollToBottom();
    }

    Future.delayed(
        const Duration(milliseconds: 500), () {
        _scrollToBottom();
      });
  });
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
          title: Text(snapshot.data ?? 'C h a t M e s s a g e s',
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
        body: Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: const [0, 0.5, 1],
                    begin: const AlignmentDirectional(-1, -1),
                    end: const AlignmentDirectional(1, 1),
            colors: [
                      FlutterFlowTheme.of(context).primary,
                      FlutterFlowTheme.of(context).error,
                      FlutterFlowTheme.of(context).tertiary
                    ],
          ),
        ),
        child: Column(
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
                          controller: _scrollController,
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
                                  width: MediaQuery.of(context).size.width * 0.8, // Set the width to half of the screen width
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
                      focusNode: myFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add padding
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Add border radius
                          borderSide: BorderSide.none, // Remove border
                        ),
                        filled: true, // Fill the text field
                        fillColor: Colors.grey[200], // Set the fill color
                      ),
                      minLines: 1, // Minimum 1 line
                      maxLines: null, // Unlimited lines
                      //onFieldSubmitted: (text) => _sendMessage(widget.otherUserId, text), // Send the message when the enter button is pressed if needed for later
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.send,
                      color: Colors.green,),
                      onPressed: () => _sendMessage(widget.otherUserId, _messageController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      );
      }
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }
}