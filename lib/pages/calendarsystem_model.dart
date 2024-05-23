import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingException implements Exception {
  final String message;
  BookingException(this.message);
}

abstract class BookingModel extends FlutterFlowModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {}

  // Other methods and properties of BookingModel...

  // Function to set tutor availability
  Future<void> setAvailability(
    String tutorId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      final data = {
        'tutorId': tutorId,
        'startTime': startTime,
        'endTime': endTime,
      };

      // Store availability in Firestore
      await _firestore.collection('availability').add(data);
    } catch (e) {
      throw BookingException('Unable to set availability.');
    }
  }

  // Function to book a session
  Future<void> bookSession(
    String tutorId,
    String studentId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      final data = {
        'tutorId': tutorId,
        'studentId': studentId,
        'startTime': startTime,
        'endTime': endTime,
      };

      // Store booking in Firestore
      await _firestore.collection('bookings').add(data);
    } catch (e) {
      throw BookingException('Unable to book session.');
    }
  }

  // Function to fetch available slots for booking
  Future<List<DocumentSnapshot>> getAvailableSlots(DateTime date) async {
    try {
      final snapshot = await _firestore
          .collection('availability')
          .where('startTime', isGreaterThanOrEqualTo: date)
          .where('endTime', isLessThanOrEqualTo: date.add(Duration(days: 1)))
          .get();
      return snapshot.docs;
    } catch (e) {
      throw BookingException('Unable to fetch available slots.');
    }
  }
}
