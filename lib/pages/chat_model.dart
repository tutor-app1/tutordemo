import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatModel {

  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get all conversations
  Stream<QuerySnapshot> getConversations(String userId) {
    //print('User ID: $userId');
    return _firestore
      .collection('messages')
      .where('users', arrayContains: userId)
      .orderBy('timestamp', descending: true)
      .snapshots();
  }

  // get messages in a conversation
  Stream<QuerySnapshot> getMessages(String conversationId) {
    return _firestore
      .collection('messages')
      .doc(conversationId)
      .collection('chats')
      .orderBy('timestamp', descending: false)
      .snapshots();
  }
}

class Message {
  
  final String sender;
  final String reciever;
  final String message;
  final Timestamp timestamp;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Message({
    required this.sender,
    required this.reciever,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'reciever': reciever,
      'message': message,
      'timestamp': timestamp,
    };
  }

  Future<void> sendMessage() async {
    final user = _auth.currentUser;
    
    List<String> ids = [user!.uid, reciever]; 
    ids.sort(); // sort so they are always in the same order
    String conversationId = ids.join('-');

    // add the users to the conversation doc
    await _firestore.collection('messages').doc(conversationId).set({
      'users': ids,
      'lastMessage': message,
      'timestamp': timestamp,
    }, SetOptions(merge: true));

    // add the msg to firestore
    await _firestore.collection('messages').doc(conversationId).collection('chats').add(toMap());
  }
}