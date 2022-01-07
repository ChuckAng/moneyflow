import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePickerController extends GetxController {
  DateTime selectedDate = DateTime.now();
  RxBool dateChanged = false.obs;

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022, 01),
      lastDate: DateTime(2100, 01),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      dateChanged.value = true;
    }

    Future.delayed(2.seconds, () {
      dateChanged.value = false;
    });

    update();
  }
}
