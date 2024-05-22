import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'review_creation.dart' show ReviewCreationWidget;
import 'package:flutter/material.dart';

class ReviewCreationModel extends FlutterFlowModel<ReviewCreationWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for RatingBar widget.
  double ratingBarValue = 3;
  String ratingDescValue = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
