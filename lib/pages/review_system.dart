import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsGet {
  // Untested, closed beta

  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get specific review
  Stream<QuerySnapshot> getReview(String tutorId, String studentId) {
    return _firestore
      .collection('reviews')
      .where("tutor", isEqualTo: tutorId)
      .where("student", isEqualTo: studentId)
      .snapshots();
  }

  // get all reviews of a specific tutor
  Stream<QuerySnapshot> getReviews(String tutorId) {
    return _firestore
      .collection('reviews')
      .where('tutor', isEqualTo: tutorId)
      .snapshots();
  }

    Future<String> fetchUserName(String? tutorId) async {
    //print('Tutor ID: $tutorId');
    String userName = '';
    final DocumentSnapshot userSnapshot =
        await _firestore.collection('tutor').doc(tutorId).get();
    //print('Tutor document: ${userSnapshot.data()}');

    if (userSnapshot.exists &&
        (userSnapshot.data() as Map).containsKey('username')) {
      userName = userSnapshot['username'];
    } else {
      final DocumentSnapshot studentSnapshot =
          await _firestore.collection('student').doc(tutorId).get();
      if (studentSnapshot.exists &&
          (studentSnapshot.data() as Map).containsKey('username')) {
        userName = studentSnapshot['username'];
      }
    }
    //print('Fetched username: $userName');
    return userName;
  }
}

class Review {
  
  final double stars;
  final String student;
  final String studentfeedback;
  final String tutor;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Review({
    required this.stars,
    required this.student,
    required this.studentfeedback,
    required this.tutor,
  });

    Map<String, dynamic> toMap() {
    return {
      'stars': stars,
      'student': student,
      'studentfeedback': studentfeedback,
      'tutor' : tutor,
    };
  }

  // Set a review
  Future<void> postReview() async {
      
    List<String> ids = [student, tutor]; 
    ids.sort(); // sort so they are always in the same order
    String reviewId = ids.join('-');
    
    // add the data to the firebase
    await _firestore.collection('reviews').doc(reviewId).set({
      'stars': stars,
      'student': student,
      'studentfeedback': studentfeedback,
      'tutor' : tutor,
      'timestamp' : DateTime.now(),
    }, SetOptions(merge: true));
  }
}