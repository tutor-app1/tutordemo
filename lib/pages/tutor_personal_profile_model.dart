import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'tutor_personal_profile.dart' show TutorPersonalProfileWidget;
import 'package:flutter/material.dart';

class TutorPersonalProfileModel extends FlutterFlowModel<TutorPersonalProfileWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}