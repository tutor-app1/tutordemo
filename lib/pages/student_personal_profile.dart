import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'student_personal_profile_model.dart';
export 'student_personal_profile_model.dart';

class StudentPersonalProfileWidget extends StatefulWidget {
  const StudentPersonalProfileWidget({super.key});

  @override
  State<StudentPersonalProfileWidget> createState() => _StudentPersonalProfileWidgetState();
}

class _StudentPersonalProfileWidgetState extends State<StudentPersonalProfileWidget> {
  late StudentPersonalProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StudentPersonalProfileModel());

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
              Navigator.pushNamed(context, '/student_UI');
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
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
                    fit: BoxFit.cover,
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
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                          child: Text(
                            'Dr. Will Hobbiton',
                            style: FlutterFlowTheme.of(context).headlineMedium,
                          ),
                        ),
                        Text(
                          'Primary Care, Intentional Medicine',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                        const Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0)),
// rating bar goes here [check btm for code]
                        Align(
                          alignment: const AlignmentDirectional(-1, 0),
                          child: Text(
                            'EDUCATION',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
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
                                      'M. PHIL',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                            color: FlutterFlowTheme.of(context)
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
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: FFButtonWidget(
                            onPressed: () {
                            },
                            text: 'Book Appointment',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 48,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
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
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: FFButtonWidget(
                            onPressed: () {
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
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context).bodyLarge,
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