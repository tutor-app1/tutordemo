import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'studentUI_page_model.dart';
export 'studentUI_page_model.dart';

class StudentUIpageWidget extends StatefulWidget {
  const StudentUIpageWidget({super.key});

  @override
  State<StudentUIpageWidget> createState() => _StudentUIpageWidgetState();
}

class _StudentUIpageWidgetState extends State<StudentUIpageWidget> {
  late StudentUIpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StudentUIpageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 6, 0, 6),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primaryText,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://picsum.photos/seed/626/600',
                    width: 400,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Text(
              'Your name',
              style: FlutterFlowTheme.of(context).headlineMedium,
            ),
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 20,
                  buttonSize: 40,
                  icon: Icon(
                    Icons.notifications_none,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24,
                  ),
                  onPressed: () {
                    print('NotifButton pressed ...');
                  },
                ),
              ),
            ],
            centerTitle: false,
            elevation: 0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 300,
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Search tutors...',
                              labelStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              hintStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding:
                                  EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                              suffixIcon: Icon(
                                Icons.search_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            cursorColor: FlutterFlowTheme.of(context).primary,
                            validator: _model.textControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: '',
                        icon: Icon(
                          Icons.filter_list_alt,
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          width: 52,
                          height: 50,
                          padding: EdgeInsets.all(14),
                          iconPadding: EdgeInsets.all(0),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).success,
                                  ),
                          elevation: 3,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                  child: Text(
                    'Find Tutor',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ListView(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    8,
                    0,
                    44,
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryText,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  'https://picsum.photos/seed/287/600',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tutor Name',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 4, 0),
                                          child: Icon(
                                            Icons.tab,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 16, 0),
                                          child: Text(
                                            'Subjects',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 4, 0),
                                          child: Icon(
                                            Icons.apartment,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16,
                                          ),
                                        ),
                                        Text(
                                          'University name',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall,
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(height: 4)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryText,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  'https://picsum.photos/seed/287/600',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tutor Name',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 4, 0),
                                          child: Icon(
                                            Icons.tab,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 16, 0),
                                          child: Text(
                                            'Subjects',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 4, 0),
                                          child: Icon(
                                            Icons.apartment,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16,
                                          ),
                                        ),
                                        Text(
                                          'University name',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall,
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(height: 4)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryText,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  'https://picsum.photos/seed/287/600',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tutor Name',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 4, 0),
                                          child: Icon(
                                            Icons.tab,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 16, 0),
                                          child: Text(
                                            'Subjects',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 4, 0),
                                          child: Icon(
                                            Icons.apartment,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16,
                                          ),
                                        ),
                                        Text(
                                          'University name',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall,
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(height: 4)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryText,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  'https://picsum.photos/seed/287/600',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tutor Name',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 4, 0),
                                          child: Icon(
                                            Icons.tab,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 16, 0),
                                          child: Text(
                                            'Subjects',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 4, 0),
                                          child: Icon(
                                            Icons.apartment,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16,
                                          ),
                                        ),
                                        Text(
                                          'University name',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall,
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(height: 4)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
