import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'landing_page.dart' show Onboarding1Widget;
import 'package:flutter/material.dart';

class Onboarding1Model extends FlutterFlowModel<Onboarding1Widget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
