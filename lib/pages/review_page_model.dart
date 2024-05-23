import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'review_page.dart' show ReviewPageWidget;
import 'package:flutter/material.dart';

class ReviewPageModel extends FlutterFlowModel<ReviewPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for RatingBar widget.
  double? ratingBarValue1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
