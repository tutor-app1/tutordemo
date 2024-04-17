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
      await FirebaseFirestore.instance
          .collection('availability')
          .doc(user.uid)
          .set(days);
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
                      'Days of the Week',
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
                        print('IconButton pressed ...');
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
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monday',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: 0,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue1 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue1 = newValue);
                            },
                            activeColor:
                                FlutterFlowTheme.of(context).primaryText,
                            activeTrackColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            inactiveTrackColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            inactiveThumbColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                          TextButton(
                            child: Text(days['Monday']['from'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Monday', 'from'),
                          ),
                          TextButton(
                            child: Text(days['Monday']['to'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Monday', 'to'),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tuesday',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: 0,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue2 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue2 = newValue);
                            },
                            activeColor:
                                FlutterFlowTheme.of(context).primaryText,
                            activeTrackColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            inactiveTrackColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            inactiveThumbColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                          TextButton(
                            child:
                                Text(days['Tuesday']['from'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Tuesday', 'from'),
                          ),
                          TextButton(
                            child: Text(days['Tuesday']['to'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Tuesday', 'to'),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Wednesday',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: 0,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue3 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue3 = newValue);
                            },
                            activeColor:
                                FlutterFlowTheme.of(context).primaryText,
                            activeTrackColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            inactiveTrackColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            inactiveThumbColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                          TextButton(
                            child:
                                Text(days['Wednesday']['from'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Wednesday', 'from'),
                          ),
                          TextButton(
                            child:
                                Text(days['Wednesday']['to'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Wednesday', 'to'),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Thursday',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: 0,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue4 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue4 = newValue);
                            },
                            activeColor:
                                FlutterFlowTheme.of(context).primaryText,
                            activeTrackColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            inactiveTrackColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            inactiveThumbColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                          TextButton(
                            child:
                                Text(days['Thursday']['from'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Thursday', 'from'),
                          ),
                          TextButton(
                            child: Text(days['Thursday']['to'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Thursday', 'to'),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Friday',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: 0,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue5 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue5 = newValue);
                            },
                            activeColor:
                                FlutterFlowTheme.of(context).primaryText,
                            activeTrackColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            inactiveTrackColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            inactiveThumbColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                          TextButton(
                            child: Text(days['Friday']['from'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Friday', 'from'),
                          ),
                          TextButton(
                            child: Text(days['Friday']['to'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Friday', 'to'),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Saturday',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: 0,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue6 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue6 = newValue);
                            },
                            activeColor:
                                FlutterFlowTheme.of(context).primaryText,
                            activeTrackColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            inactiveTrackColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            inactiveThumbColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                          TextButton(
                            child:
                                Text(days['Saturday']['from'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Saturday', 'from'),
                          ),
                          TextButton(
                            child: Text(days['Saturday']['to'].format(context)),
                            onPressed: () =>
                                selectTime(context, 'Saturday', 'to'),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sunday',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: 0,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue7 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue7 = newValue);
                            },
                            activeColor:
                                FlutterFlowTheme.of(context).primaryText,
                            activeTrackColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            inactiveTrackColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            inactiveThumbColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                          ElevatedButton(
                            onPressed: saveAvailability,
                            child: const Text('Save Availability'),
                          )
                        ],
                      ),
                    ],
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
