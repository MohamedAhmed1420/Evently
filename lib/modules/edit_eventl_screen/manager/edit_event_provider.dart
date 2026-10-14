import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constante/app_category.dart';
import '../../../../core/models/event_model.dart';
import '../../../../core/services/db_service.dart';

class EditEventProvider extends ChangeNotifier {
  late EventModel event;
  int index = 0;
  AppCategory selectedCategory = AppCategory.categories.first;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DateTime? selectedDateTime;
  TimeOfDay? selectedTime;
  bool isLoading = false;
  bool isInitialized = false;

  void init(EventModel eventModel) {
    if (isInitialized) return;
    event = eventModel;
    titleController.text = event.title;
    descController.text = event.desc;

    index = AppCategory.categories.indexWhere((cat) => cat.id == event.categoryId);
    if (index == -1) index = 0;
    selectedCategory = AppCategory.categories[index];

    if (event.date.isNotEmpty) {
      DateTime? parsed = DateTime.tryParse(event.date);
      if (parsed != null) {
        selectedDateTime = parsed;
      } else {
        try {
          selectedDateTime = DateFormat.yMd().parse(event.date);
        } catch (_) {
          try {
            List<String> dateParts = event.date.split('/');
            if (dateParts.length == 3) {
              selectedDateTime = DateTime(
                int.parse(dateParts[2]),
                int.parse(dateParts[0]),
                int.parse(dateParts[1]),
              );
            }
          } catch (_) {}
        }
      }
    }

    isInitialized = true;
  }

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

  Future<void> updateEvent(BuildContext context) async {
    if (titleController.text.trim().isEmpty ||
        descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      event.title = titleController.text.trim();
      event.desc = descController.text.trim();
      event.categoryId = selectedCategory.id;

      if (selectedDateTime != null) {
        event.date = DateFormat.yMd().format(selectedDateTime!);
      }
      if (selectedTime != null) {
        event.time = selectedTime!.format(context);
      }

      await DbService.updateEvent(event);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event updated successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update event: $e")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }
}
