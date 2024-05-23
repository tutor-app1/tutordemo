import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'review_system.dart';
import 'review_creation_model.dart';
export 'review_creation_model.dart';

class ReviewCreationWidget extends StatefulWidget {
  final String otherUserId;
  final String tutorId;

  const ReviewCreationWidget(
      {required Key key, required this.otherUserId, required this.tutorId})
      : super(key: key);

  @override
  State<ReviewCreationWidget> createState() => _ReviewCreationWidgetState();
}

class _ReviewCreationWidgetState extends State<ReviewCreationWidget> {
  late ReviewCreationModel _model;
  final ReviewsGet _reviews = ReviewsGet();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewCreationModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
    _descriptionController.dispose();
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: StreamBuilder<QuerySnapshot>(
            stream: _reviews.getReview(
              widget.tutorId, FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                if (documents.isNotEmpty) {
                  final DocumentSnapshot review = documents.first;
                  _model.description = review['studentfeedback'];
                  _model.rating = review['stars'];
                }
              }

              _descriptionController.text = _model.description;
              return Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(-0.95, -0.19),
                    child: FFButtonWidget(
                      onPressed: () {
                        var _review = Review(
                          stars: _model.rating,
                          student: FirebaseAuth.instance.currentUser!.uid,
                          studentfeedback: _model.description,
                          tutor: widget.tutorId);
                        _review.postReview();
                        Navigator.pop(context);
                      },
                      text: 'Submit',
                      options: FFButtonOptions(
                        height: 40,
                        padding:
                          EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                        elevation: 3,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, -0.7),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                      child: TextFormField(
                        onChanged: (newValue) => setState(
                            () => _model.description = newValue),
                        controller: _descriptionController,
                        focusNode: _model.textFieldFocusNode,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Write your description here',
                          labelStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: 'Readex Pro',
                                letterSpacing: 0,
                              ),
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: 'Readex Pro',
                                letterSpacing: 0,
                              ),
                              enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                        textAlign: TextAlign.start,
                        maxLines: null,
                        maxLength: 400,
                        validator: _model.textControllerValidator
                          .asValidator(context),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-0.96, -0.85),
                    child: RatingBar.builder(
                      onRatingUpdate: (newValue) =>
                          setState(() => _model.rating = newValue),
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: FlutterFlowTheme.of(context).tertiary,
                      ),
                      direction: Axis.horizontal,
                      initialRating: _model.rating,
                      unratedColor: FlutterFlowTheme.of(context).accent3,
                      itemCount: 5,
                      itemSize: 40,
                      glowColor: FlutterFlowTheme.of(context).tertiary,
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
