import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsGet {
  // Untested, closed beta

  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get one review
  Future<Map<String, dynamic>?> getReview(String tutorId, String studentId) async {
    CollectionReference collection = _firestore.collection('reviews');
    Query idMatch = collection.where("student", isEqualTo: studentId)
    .where("tutor", isEqualTo: tutorId);
    QuerySnapshot qSnap = await idMatch.get();
    
    return qSnap.docs.first.data() as Map<String, dynamic>?;
  }

  // get all reviews of a specific tutor
  Future<Map<String, dynamic>?> getReviews(String tutorId) async {
    CollectionReference collection = _firestore.collection('reviews');
    Query idMatch = collection.where("tutor", isEqualTo: tutorId);
    QuerySnapshot qSnap = await idMatch.get();

    return qSnap.docs.first.data() as Map<String, dynamic>?;
  }
}

//   Stream<QuerySnapshot> getReview(String tutorId, String studentId) {
//     return _firestore
//       .collection('reviews')
//       .where('tutor', arrayContains: tutorId) 
//       .where('student', arrayContains: studentId)
//       .snapshots();
//   }

//   // get all reviews of a specific tutor
//   Stream<QuerySnapshot> getReviews(String tutorId) {
//     return _firestore
//       .collection('reviews')
//       .where('tutorID', arrayContains: tutorId)
//       .snapshots();
//   }
// }

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

    print('firebase shenanigans');
  }
}