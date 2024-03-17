import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'updatepassword_widget.dart' show UpdatepasswordWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdatepasswordModel extends FlutterFlowModel<UpdatepasswordWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for oldpassword widget.
  FocusNode? oldpasswordFocusNode;
  TextEditingController? oldpasswordController;
  String? Function(BuildContext, String?)? oldpasswordControllerValidator;
  // State field(s) for newpassword widget.
  FocusNode? newpasswordFocusNode;
  TextEditingController? newpasswordController;
  String? Function(BuildContext, String?)? newpasswordControllerValidator;
  // State field(s) for newpassword2 widget.
  FocusNode? newpassword2FocusNode;
  TextEditingController? newpassword2Controller;
  String? Function(BuildContext, String?)? newpassword2ControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    oldpasswordFocusNode?.dispose();
    oldpasswordController?.dispose();

    newpasswordFocusNode?.dispose();
    newpasswordController?.dispose();

    newpassword2FocusNode?.dispose();
    newpassword2Controller?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
