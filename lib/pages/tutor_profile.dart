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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TutorProfileModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

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
                                  if (value['available']) {
                                    DateTime date = DateTime.now().add(Duration(
                                        days: [
                                      'Sunday',
                                      'Monday',
                                      'Tuesday',
                                      'Wednesday',
                                      'Thursday',
                                      'Friday',
                                      'Saturday'
                                    ].indexOf(key))); // convert key to DateTime
                                    List<String> timeSlots = _generateTimeSlots(
                                        value['from'],
                                        value[
                                            'to']); // generate time slots from 'from' to 'to'
                                    events[date] = timeSlots;
                                  }
                                });

                                // Show dialog
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: TableCalendar(
                                            firstDay: DateTime.now(),
                                            lastDay: DateTime.now()
                                                .add(const Duration(days: 7)),
                                            focusedDay: DateTime.now(),
                                            eventLoader: (day) {
                                              return events[day] ?? [];
                                            },
                                            calendarStyle: const CalendarStyle(
                                                // Customize calendar style here
                                                // Use `markersColor` to change the color of the markers
                                                ),
                                            onDaySelected:
                                                (selectedDay, focusedDay) {
                                              // Show available time slots
                                              showDialog(
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
                                                            0.2,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    child: ListView.builder(
                                                      itemCount:
                                                          events[selectedDay]
                                                                  ?.length ??
                                                              0,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: Text(events[
                                                                  selectedDay]![
                                                              index]),
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