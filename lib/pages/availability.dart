import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'availability_model.dart';
export 'availability_model.dart';

class AvailabilityWidget extends StatefulWidget {
  const AvailabilityWidget({super.key});

  @override
  State<AvailabilityWidget> createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  late AvailabilityModel _model;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> days = {
    'Monday': {
      'available': false,
      'from': TimeOfDay.now(),
      'to': TimeOfDay.now()
    },
    'Tuesday': {
      'available': false,
      'from': TimeOfDay.now(),
      'to': TimeOfDay.now()
    },
    'Wednesday': {
      'available': false,
      'from': TimeOfDay.now(),
      'to': TimeOfDay.now()
    },
    'Thursday': {
      'available': false,
      'from': TimeOfDay.now(),
      'to': TimeOfDay.now()
    },
    'Friday': {
      'available': false,
      'from': TimeOfDay.now(),
      'to': TimeOfDay.now()
    },
    'Saturday': {
      'available': false,
      'from': TimeOfDay.now(),
      'to': TimeOfDay.now()
    },
    'Sunday': {
      'available': false,
      'from': TimeOfDay.now(),
      'to': TimeOfDay.now()
    },
  };

  Future<void> selectTime(BuildContext context, String day, String when) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: days[day][when],
    );
    if (picked != null && picked != days[day][when]) {
      setState(() {
        days[day][when] = picked;
      });
    }
  }

  Future<void> saveAvailability() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      Map<String, dynamic> daysToSave = {};
      days.forEach((key, value) {
        daysToSave[key] = {
          'available': value['available'] ?? false,
          'from': '${value['from'].hour}:${value['from'].minute}',
          'to': '${value['to'].hour}:${value['to'].minute}',
        };
      });
      await FirebaseFirestore.instance
          .collection('availability')
          .doc(user.uid)
          .set(daysToSave);
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvailabilityModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Schedule for the week',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                letterSpacing: 0,
                              ),
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 30,
                      buttonSize: 60,
                      icon: Icon(
                        Icons.close_rounded,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Sunday',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Switch(
                              value: _model.switchValue7 ??= false,
                              onChanged: (newValue) async {
                                setState(() {
                                  _model.switchValue7 = newValue;
                                  days['Sunday']['available'] = newValue;
                                });
                              },
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              inactiveTrackColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              inactiveThumbColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child:
                                  Text(days['Sunday']['from'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Sunday', 'from'),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(days['Sunday']['to'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Sunday', 'to'),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Monday',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Switch(
                              value: _model.switchValue1 ??= false,
                              onChanged: (newValue) async {
                                setState(() {
                                  _model.switchValue1 = newValue;
                                  days['Monday']['available'] = newValue;
                                });
                              },
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              inactiveTrackColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              inactiveThumbColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child:
                                  Text(days['Monday']['from'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Monday', 'from'),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(days['Monday']['to'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Monday', 'to'),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Tuesday',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Switch(
                              value: _model.switchValue2 ??= false,
                              onChanged: (newValue) async {
                                setState(() {
                                  _model.switchValue2 = newValue;
                                  days['Tuesday']['available'] = newValue;
                                });
                              },
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              inactiveTrackColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              inactiveThumbColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child:
                                  Text(days['Tuesday']['from'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Tuesday', 'from'),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child:
                                  Text(days['Tuesday']['to'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Tuesday', 'to'),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Wednesday',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Switch(
                              value: _model.switchValue3 ??= false,
                              onChanged: (newValue) async {
                                setState(() {
                                  _model.switchValue3 = newValue;
                                  days['Wednesday']['available'] = newValue;
                                });
                              },
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              inactiveTrackColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              inactiveThumbColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(
                                  days['Wednesday']['from'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Wednesday', 'from'),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child:
                                  Text(days['Wednesday']['to'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Wednesday', 'to'),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Thursday',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Switch(
                              value: _model.switchValue4 ??= false,
                              onChanged: (newValue) async {
                                setState(() {
                                  _model.switchValue4 = newValue;
                                  days['Thursday']['available'] = newValue;
                                });
                              },
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              inactiveTrackColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              inactiveThumbColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(
                                  days['Thursday']['from'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Thursday', 'from'),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child:
                                  Text(days['Thursday']['to'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Thursday', 'to'),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Friday',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Switch(
                              value: _model.switchValue5 ??= false,
                              onChanged: (newValue) async {
                                setState(() {
                                  _model.switchValue5 = newValue;
                                  days['Friday']['available'] = newValue;
                                });
                              },
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              inactiveTrackColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              inactiveThumbColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child:
                                  Text(days['Friday']['from'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Friday', 'from'),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(days['Friday']['to'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Friday', 'to'),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Saturday',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Switch(
                              value: _model.switchValue6 ??= false,
                              onChanged: (newValue) async {
                                setState(() {
                                  _model.switchValue6 = newValue;
                                  days['Saturday']['available'] = newValue;
                                });
                              },
                              activeColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              inactiveTrackColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              inactiveThumbColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(
                                  days['Saturday']['from'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Saturday', 'from'),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child:
                                  Text(days['Saturday']['to'].format(context)),
                              onPressed: () =>
                                  selectTime(context, 'Saturday', 'to'),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          await saveAvailability();
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Availability saved',
                                  style: TextStyle(color: Colors.green)),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        },
                        child: const Text('Save Availability'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
