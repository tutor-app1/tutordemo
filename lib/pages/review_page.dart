import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'review_system.dart';
import 'review_page_model.dart';
export 'review_page_model.dart';

class ReviewPageWidget extends StatefulWidget {
  const ReviewPageWidget({super.key});

  @override
  State<ReviewPageWidget> createState() => ReviewPageWidgetState();
}

class ReviewPageWidgetState extends State<ReviewPageWidget> {
  late ReviewPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ReviewsGet _reviews = ReviewsGet();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String tutorId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          buttonSize: 46,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _reviews.getReviews(tutorId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    final reviewList = <Review>[]; 
                    if (documents.isNotEmpty) {
                      for (var document in documents) {
                        final data = document.data() as Map<String, dynamic>;

                        var _review = Review (
                          stars: data['stars'],
                          student: data['student'],
                          studentfeedback: data['studentfeedback'],
                          tutor: data['tutor'],
                        );
                        reviewList.add(_review);
                      }
                    } else {
                      return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                              Text(
                                "No reviews found",
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .copyWith(
                                        color: FlutterFlowTheme.of(
                                                context)
                                            .primaryText),
                              ),
                          ],
                      );
                    }

                    return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 44),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: reviewList.length,
                          itemBuilder: (context, index) {
                            Review review = reviewList[index];
                            return Container(
                            width: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 12, 16, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              review.student,
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .copyWith(
                                                      color: FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 4, 0),
                                                  child: Icon(
                                                    Icons.tab,
                                                    color:
                                                        FlutterFlowTheme.of(context)
                                                            .primaryText,
                                                    size: 26,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 16, 0),
                                                  child: Align(
                                                    alignment: const AlignmentDirectional(-0.96, -0.85),
                                                    child: RatingBarIndicator(
                                                      rating: review.stars,
                                                      itemBuilder: (context, index) => Icon(
                                                        Icons.star_rounded,
                                                        color: FlutterFlowTheme.of(context).tertiary,
                                                      ),
                                                      direction: Axis.horizontal,
                                                      unratedColor: FlutterFlowTheme.of(context).accent3,
                                                      itemCount: 5,
                                                      itemSize: 45,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 4, 0),
                                                  child: Icon(
                                                    Icons.apartment,
                                                    color:
                                                        FlutterFlowTheme.of(context)
                                                            .primaryText,
                                                    size: 28,
                                                  ),
                                                ),
                                                Text(
                                                  review.studentfeedback,
                                                  style: FlutterFlowTheme.of(context)
                                                    .bodyLarge.copyWith(color:
                                                      FlutterFlowTheme.of(context)
                                                        .primaryText),
                                                ),
                                              ],
                                            ),
                                          ].divide(const SizedBox(height: 4)),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
            ),
          ),
        ],
      ),
    ); 
  }
}
