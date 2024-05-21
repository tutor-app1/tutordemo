import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  // Untested, closed beta

  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get one review
  Stream<QuerySnapshot> getReview(String tutorId, String studentId) {
    return _firestore
      .collection('reviews')
      .where('tutor', arrayContains: tutorId) 
      .where('student', arrayContains: studentId)
      .snapshots();
  }

  // get all reviews of a specific tutor
  Stream<QuerySnapshot> getReviews(String tutorId) {
    return _firestore
      .collection('reviews')
      .where('tutorID', arrayContains: tutorId)
      .snapshots();
  }
}

class Review {
  
  final Int stars;
  final String student;
  final String studentfeedback;
  final String tutor;
  final Timestamp timestamp;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Review({
    required this.stars,
    required this.student,
    required this.studentfeedback,
    required this.tutor,
    required this.timestamp,
  });

    Map<String, dynamic> toMap() {
    return {
      'stars': stars,
      'student': student,
      'studentfeedback': studentfeedback,
      'tutor' : tutor,
      'timestamp': timestamp,
    };
  }

  // Set a review
  Future<void> postReview() async {
      
    List<String> ids = [student, tutor]; 
    ids.sort(); // sort so they are always in the same order
    String reviewId = ids.join('-');
    
    // add the data to the review doc
    await _firestore.collection('reviews').doc(reviewId).set({
      'stars': stars,
      'student': student,
      'studentfeedback': studentfeedback,
      'tutor' : tutor,
      'timestamp' : timestamp,
    }, SetOptions(merge: true));

    // add the review to firestore
    await _firestore.collection('reviews').add(toMap());
  }
}