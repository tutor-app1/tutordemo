import 'package:flutter/material.dart';
import 'availability.dart' show AvailabilityWidget;
import 'package:flutterflow_ui/flutterflow_ui.dart';

class AvailabilityModel extends FlutterFlowModel<AvailabilityWidget> {
  // Add your state variables here
  Map<String, List<TimeOfDay>> availability = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  // Function to add a time slot to a day
  void addTimeSlot(String day, TimeOfDay timeSlot) {
    availability[day]?.add(timeSlot);
  }

  // Function to remove a time slot from a day
  void removeTimeSlot(String day, TimeOfDay timeSlot) {
    availability[day]?.remove(timeSlot);
  }

  final unfocusNode = FocusNode();
  // State field(s) for Switch widget.
  bool? switchValue1;
  // State field(s) for Switch widget.
  bool? switchValue2;
  // State field(s) for Switch widget.
  bool? switchValue3;
  // State field(s) for Switch widget.
  bool? switchValue4;
  // State field(s) for Switch widget.
  bool? switchValue5;
  // State field(s) for Switch widget.
  bool? switchValue6;
  // State field(s) for Switch widget.
  bool? switchValue7;

  // State field(s) for TimePicker widget.
  TimeOfDay? timePickerValue;

  // State field(s) for TimePicker widget.
  TimeOfDay? timePickerValue2;

  // State field(s) for TimePicker widget.
  TimeOfDay? timePickerValue3;

  // State field(s) for TimePicker widget.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
