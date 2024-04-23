import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'availability_model.dart';
export 'availability_model.dart';

class AvailabilityWidget extends StatefulWidget {
  const AvailabilityWidget({super.key});

  @override
  State<AvailabilityWidget> createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  late AvailabilityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
        backgroundColor: Color(0xFFF1F4F8),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                                color: Color(0xFF15161E),
                                fontSize: 24,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 30,
                      buttonSize: 60,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Color(0xFF15161E),
                        size: 30,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                                  color: Color(0xFF15161E),
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue1 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue1 = newValue!);
                            },
                            activeColor: Color(0xFF15161E),
                            activeTrackColor: Color(0xFF606A85),
                            inactiveTrackColor: Color(0xFFF1F4F8),
                            inactiveThumbColor: Color(0xFF606A85),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
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
                                  color: Color(0xFF15161E),
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue2 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue2 = newValue!);
                            },
                            activeColor: Color(0xFF15161E),
                            activeTrackColor: Color(0xFF606A85),
                            inactiveTrackColor: Color(0xFFF1F4F8),
                            inactiveThumbColor: Color(0xFF606A85),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
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
                                  color: Color(0xFF15161E),
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue3 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue3 = newValue!);
                            },
                            activeColor: Color(0xFF15161E),
                            activeTrackColor: Color(0xFF606A85),
                            inactiveTrackColor: Color(0xFFF1F4F8),
                            inactiveThumbColor: Color(0xFF606A85),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
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
                                  color: Color(0xFF15161E),
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue4 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue4 = newValue!);
                            },
                            activeColor: Color(0xFF15161E),
                            activeTrackColor: Color(0xFF606A85),
                            inactiveTrackColor: Color(0xFFF1F4F8),
                            inactiveThumbColor: Color(0xFF606A85),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
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
                                  color: Color(0xFF15161E),
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue5 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue5 = newValue!);
                            },
                            activeColor: Color(0xFF15161E),
                            activeTrackColor: Color(0xFF606A85),
                            inactiveTrackColor: Color(0xFFF1F4F8),
                            inactiveThumbColor: Color(0xFF606A85),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
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
                                  color: Color(0xFF15161E),
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue6 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue6 = newValue!);
                            },
                            activeColor: Color(0xFF15161E),
                            activeTrackColor: Color(0xFF606A85),
                            inactiveTrackColor: Color(0xFFF1F4F8),
                            inactiveThumbColor: Color(0xFF606A85),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
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
                                  color: Color(0xFF15161E),
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          Switch(
                            value: _model.switchValue7 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue7 = newValue!);
                            },
                            activeColor: Color(0xFF15161E),
                            activeTrackColor: Color(0xFF606A85),
                            inactiveTrackColor: Color(0xFFF1F4F8),
                            inactiveThumbColor: Color(0xFF606A85),
                          ),
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
