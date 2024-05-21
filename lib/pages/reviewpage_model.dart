import 'package:flutterflow_ui/flutterflow_ui.dart';

// Came as a part of the FlutterFlow template but files arent provided
// import '/flutter_flow/flutter_flow_icon_button.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';

import 'reviewpage.dart' show ReviewpageWidget;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReviewpageModel extends FlutterFlowModel<ReviewpageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for RatingBar widget.
  double? ratingBarValue1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
