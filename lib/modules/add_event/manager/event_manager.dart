import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constante/app_category.dart';
import '../../../core/models/event_model.dart';
import '../../../core/services/db_service.dart';

class EventProvider extends ChangeNotifier {
  int index = 0;

  AppCategory selectedCategory = AppCategory.categories.first;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DateTime? selectedDateTime;

  TimeOfDay? selectedTime;

  void changeIndex(int value) {
    index = value;
    selectedCategory = AppCategory.categories[index];
    notifyListeners();
  }

  void changeDate(DateTime date) {
    selectedDateTime = date;
    notifyListeners();
  }

  void changeTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  bool isLoading = false;

  void addEvent(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    await DbService.addEvent(
      EventModel(
        id: "",
        categoryId: selectedCategory.id,
        date: selectedDateTime != null
            ? DateFormat.yMd().format(selectedDateTime!)
            : "",
        desc: descController.text,
        time: selectedTime != null ? selectedTime!.format(context) : "",
        title: titleController.text,
      ),
    );
    isLoading = false;
    notifyListeners();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
