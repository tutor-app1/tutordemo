import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:tutorapptrials/pages/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'tutor_profile_model.dart';
export 'tutor_profile_model.dart';

class TutorProfileWidget extends StatefulWidget {
  const TutorProfileWidget({super.key});

  @override
  State<TutorProfileWidget> createState() => _TutorProfileWidgetState();
}

class _TutorProfileWidgetState extends State<TutorProfileWidget> {
  late TutorProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController topicController = TextEditingController();
  final TextEditingController subtopicController = TextEditingController();

  Future<String> getOrCreateConversationId(
      String userId, String otherUserId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<String> ids = [userId, otherUserId];
    ids.sort(); // sort so they are always in the same order
    String conversationId = ids.join('-');

    final DocumentSnapshot docSnapshot =
        await _firestore.collection('conversations').doc(conversationId).get();

    if (!docSnapshot.exists) {
      // If the conversation doesn't exist, create it
      await _firestore.collection('conversations').doc(conversationId).set({
        'users': ids,
        // Add any other fields you need for a conversation
      });
    }

    return conversationId;
  }

  List<String> _generateTimeSlots(String from, String to) {
    List<String> timeSlots = [];
    DateFormat format = DateFormat("hh:mm"); // adjust the format as needed
    DateTime startTime = format.parse(from);
    DateTime endTime = format.parse(to);
    while (startTime.isBefore(endTime)) {
      timeSlots.add(DateFormat.jm().format(startTime));
      startTime = startTime.add(const Duration(hours: 1));
    }
    return timeSlots;
  }

  Future<void> getSlotsFromFirestore(
      String tutorId, Map<DateTime, List<String>> events) async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('tutor_slots')
        .doc(tutorId)
        .get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data.forEach((key, value) {
      //print('key: $key'); // Print the key
      //print('value: $value'); // Print the value
      DateTime date = DateTime.parse(key);
      List<String> slotsForDay = [];
      for (var slot in value) {
        if (slot['isAvailable'] == true) {
          slotsForDay.add(slot['time']);
        }
      }
      if (slotsForDay.isNotEmpty) {
        events[date] = slotsForDay;
      }
    });
  }

  void saveSlotsToFirestore(
      String tutorId, Map<DateTime, List<String>> events) {
    final DocumentReference tutorSlot =
        FirebaseFirestore.instance.collection('tutor_slots').doc(tutorId);

    events.forEach((date, slotsForDay) {
      // Convert each slot to a map with 'time' and 'isAvailable' fields
      List<Map<String, dynamic>> slots = slotsForDay.map((slot) {
        return {
          'time': slot,
          'isAvailable': true,
        };
      }).toList();

      tutorSlot.set({
        date.toIso8601String(): slots,
      }, SetOptions(merge: true));
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TutorProfileModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    topicController.dispose();
    subtopicController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic tutor = ModalRoute.of(context)!.settings.arguments;
    final String tutorId = tutor.id as String;
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30,
            ),
            onPressed: () async {
              Navigator.pop(context);
              //print('clicked');
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8ZG9jb3RyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                      width: double.infinity,
                      height: 330,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 8),
                            child: Text(
                              '${tutor['username']}',
                              style:
                                  FlutterFlowTheme.of(context).headlineMedium,
                            ),
                          ),
                          Text(
                            '${tutor['email']}',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                          const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0)),
// rating bar goes here [check btm for code]
                          Align(
                            alignment: const AlignmentDirectional(-1, 0),
                            child: Text(
                              '${tutor['subject']}',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8, 0, 12, 0),
                                      child: Text(
                                        '${tutor['educationlevel']}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                child: VerticalDivider(
                                  thickness: 4,
                                  indent: 1,
                                  endIndent: 12,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 12),
                                      child: Icon(
                                        Icons.star_rate,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8, 0, 12, 0),
                                      child: Text(
                                        'REVIEWS',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 12),
                            child: FFButtonWidget(
                              onPressed: () async {
                                // Fetch availability data
                                DocumentSnapshot doc = await FirebaseFirestore
                                    .instance
                                    .collection('availability')
                                    .doc(tutorId)
                                    .get(); // replace 'tutorId' with the actual tutor's ID
                                Map<String, dynamic> data =
                                    doc.data() as Map<String, dynamic>;

                                // Parse data
                                Map<DateTime, List> events = {};
                                data.forEach((key, value) {
                                  /*print('key: $key'); // Print the key
                                  print(
                                      'available: ${value['available']}'); // Print the 'available' field
                                  print(
                                      'from: ${value['from']}'); // Print the 'from' field
                                  print(
                                      'to: ${value['to']}'); // Print the 'to' field */
                                  if (value['available']) {
                                    // Calculate the number of days until the next occurrence of the day of the week
                                    int daysUntil(String day) {
                                      final daysOfWeek = [
                                        'Sunday',
                                        'Monday',
                                        'Tuesday',
                                        'Wednesday',
                                        'Thursday',
                                        'Friday',
                                        'Saturday'
                                      ];
                                      final now = DateTime.now();
                                      final today = daysOfWeek[now.weekday % 7];
                                      final indexToday =
                                          daysOfWeek.indexOf(today);
                                      final indexDay = daysOfWeek.indexOf(day);
                                      return (indexDay - indexToday + 7) % 7;
                                    }

                                    DateTime date = DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .add(Duration(days: daysUntil(key)));
                                    //print('date: $date'); // Print the date
                                    List<String> timeSlots = _generateTimeSlots(
                                        value['from'],
                                        value[
                                            'to']); // generate time slots from 'from' to 'to'
                                    //print('timeSlots: $timeSlots'); // Print the time slots
                                    events[date] = timeSlots;
                                  }
                                  // print(events);
                                });

                                // Convert each slot to a string
                                Map<DateTime, List<String>> stringEvents = {};
                                events.forEach((date, slotsForDay) {
                                  stringEvents[date] = slotsForDay
                                      .map((slot) => slot.toString())
                                      .toList();
                                });

                                // Save slots to Firestore
                                saveSlotsToFirestore(tutorId, stringEvents);

                                // Show dialog
                                showDialog(
                                    context: context,
                                    useSafeArea: false,
                                    builder: (context) => AlertDialog(
                                          content: SizedBox(
                                            width: double
                                                .maxFinite, // or any specific width
                                            height: double
                                                .maxFinite, // or any specific height
                                            child: TableCalendar(
                                              firstDay: DateTime.now(),
                                              lastDay: DateTime.now()
                                                  .add(const Duration(days: 7)),
                                              focusedDay: DateTime.now(),
                                              eventLoader: (day) {
                                                //print('Loading events for $day');
                                                //print(events[day] ?? []);
                                                return events[day] ??
                                                    ['No events available'];
                                              },
                                              calendarStyle: const CalendarStyle(
                                                  // Customize calendar style here
                                                  // Use `markersColor` to change the color of the markers
                                                  ),
                                              onDaySelected: (selectedDay,
                                                  focusedDay) async {
                                                // Fetch the slots for the selected day from Firestore
                                                await getSlotsFromFirestore(
                                                    tutorId, stringEvents);
                                                // Show available time slots
                                                showDialog(
                                                  useSafeArea: false,
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text(
                                                        'Available slots'),
                                                    content: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.8,
                                                      child: ListView.builder(
                                                        itemCount:
                                                            events[selectedDay]
                                                                    ?.length ??
                                                                0,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      events[selectedDay]![
                                                                          index]),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      10), // Add space
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      topicController,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    labelText:
                                                                        'Topic',
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      10), // Add space
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      subtopicController,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    labelText:
                                                                        'Subtopic',
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      10), // Add space
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  // Handle booking here
                                                                  // You can access the topic and subtopic using topicController.text and subtopicController.text
                                                                  final String
                                                                      fromTime =
                                                                      events[selectedDay]![
                                                                          index];
                                                                  final String
                                                                      topic =
                                                                      topicController
                                                                          .text;
                                                                  final String
                                                                      subtopic =
                                                                      subtopicController
                                                                          .text;
                                                                  final String
                                                                      currentUserUid =
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid;
                                                                  final Timestamp
                                                                      timestamp =
                                                                      Timestamp
                                                                          .now();

                                                                  // Save to tutor_sessions collection
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'tutor_sessions')
                                                                      .doc(
                                                                          tutorId)
                                                                      .set({
                                                                    'fromTime':
                                                                        fromTime,
                                                                    'topic':
                                                                        topic,
                                                                    'subtopic':
                                                                        subtopic,
                                                                    'studentUid':
                                                                        currentUserUid,
                                                                    'timestamp':
                                                                        timestamp,
                                                                  });

                                                                  // Save to student_sessions collection
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'student_sessions')
                                                                      .doc(
                                                                          currentUserUid)
                                                                      .set({
                                                                    'fromTime':
                                                                        fromTime,
                                                                    'topic':
                                                                        topic,
                                                                    'subtopic':
                                                                        subtopic,
                                                                    'tutorId':
                                                                        tutorId,
                                                                    'timestamp':
                                                                        timestamp,
                                                                  });

                                                                  // Replace regular space characters in 'fromTime' with non-breaking space characters
                                                                  String
                                                                      modifiedFromTime =
                                                                      fromTime.replaceAll(
                                                                          ' ',
                                                                          '\u00A0');

                                                                  // Get the reference to the 'tutor_slots' collection
                                                                  CollectionReference
                                                                      slotsCollection =
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'tutor_slots');

                                                                  // Get the document ID of the slot with the matching 'time' field
                                                                  String
                                                                      slotId =
                                                                      '';
                                                                  QuerySnapshot
                                                                      querySnapshot =
                                                                      await slotsCollection
                                                                          .where(
                                                                              'time',
                                                                              isEqualTo: modifiedFromTime)
                                                                          .get();
                                                                  if (querySnapshot
                                                                      .docs
                                                                      .isNotEmpty) {
                                                                    slotId =
                                                                        querySnapshot
                                                                            .docs
                                                                            .first
                                                                            .id;
                                                                  }

                                                                  // Update the 'isAvailable' field of the slot
                                                                  if (slotId
                                                                      .isNotEmpty) {
                                                                    await slotsCollection
                                                                        .doc(
                                                                            slotId)
                                                                        .update({
                                                                      'isAvailable':
                                                                          false
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Book'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child:
                                                            const Text('Close'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ));
                              },
                              //print('Button pressed ...');
                              text: 'Book Appointment',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                    ),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 12),
                            child: FFButtonWidget(
                              onPressed: () async {
                                final user = _auth.currentUser;
                                final String conversationId =
                                    await getOrCreateConversationId(
                                        user!.uid, tutorId);
                                //print('Tutor ID: $tutorId');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreenWidget(
                                        key: const ValueKey('chat_screen'),
                                        otherUserId: tutorId,
                                        conversationId: conversationId,
                                        tutorId: tutorId,
                                      ),
                                    ));
                              },
                              text: 'CHAT',
                              icon: Icon(
                                Icons.chat,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 15,
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyLarge,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// RatingBar.builder(
//                             onRatingUpdate: (newValue) => setState(
//                                 () => _model.ratingBarValue = newValue),
//                             itemBuilder: (context, index) => Icon(
//                               Icons.star_rounded,
//                               color: FlutterFlowTheme.of(context).warning,
//                             ),
//                             direction: Axis.horizontal,
//                             initialRating: _model.ratingBarValue ??= 4,
//                             unratedColor:
//                                 FlutterFlowTheme.of(context).alternate,
//                             itemCount: 5,
//                             itemSize: 24,
//                             glowColor: FlutterFlowTheme.of(context).warning,
//                           )