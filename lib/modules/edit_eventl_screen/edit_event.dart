import 'package:evently/core/constante/app_category.dart';
import 'package:evently/core/models/event_model.dart';
import 'package:evently/modules/layout/widgets/tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'manager/edit_event_provider.dart';

class EditEvent extends StatelessWidget {
  static const String routeName = "EditScreen";

  const EditEvent({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var event = ModalRoute.of(context)!.settings.arguments as EventModel;

    return ChangeNotifierProvider(
      create: (context) => EditEventProvider()..init(event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit event",
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<EditEventProvider>(
            builder: (context, provider, child) {
              String displayDate = "Choose Date";
              if (provider.selectedDateTime != null) {
                displayDate = DateFormat.yMd().format(provider.selectedDateTime!);
              } else if (provider.event.date.isNotEmpty) {
                DateTime? parsed = DateTime.tryParse(provider.event.date);
                if (parsed != null) {
                  displayDate = DateFormat.yMd().format(parsed);
                } else {
                  displayDate = provider.event.date;
                }
              }

              String displayTime = "Choose Time";
              if (provider.selectedTime != null) {
                displayTime = provider.selectedTime!.format(context);
              } else if (provider.event.time.isNotEmpty) {
                displayTime = provider.event.time;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Image Preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      provider.selectedCategory.image,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Selection Tabs
                  DefaultTabController(
                    length: AppCategory.categories.length,
                    initialIndex: provider.index,
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(color: Colors.transparent),
                      isScrollable: true,
                      onTap: (index) => provider.changeIndex(index),
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.all(8),
                      tabs: AppCategory.categories.map((category) {
                        int index = AppCategory.categories.indexOf(category);
                        return TabWidget(
                          category: category,
                          isSelected: provider.index == index,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title Input
                  Text(
                    "Title",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: provider.titleController,
                    style: TextStyle(color: theme.textTheme.titleLarge?.color),
                    decoration: const InputDecoration(hintText: "Event Title"),
                  ),
                  const SizedBox(height: 16),

                  // Description Input
                  Text(
                    "Description",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: TextFormField(
                      controller: provider.descController,
                      style: TextStyle(color: theme.textTheme.titleLarge?.color),
                      expands: true,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: "Event Description",
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Picker Row
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "Event Date",
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          DateTime initialDate =
                              provider.selectedDateTime ?? DateTime.now();
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate:
                                DateTime.now().subtract(const Duration(days: 365)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            provider.changeDate(pickedDate);
                          }
                        },
                        child: Text(
                          displayDate,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Time Picker Row
                  Row(
                    children: [
                      Icon(Icons.timelapse_outlined, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "Event Time",
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay initialTime =
                              provider.selectedTime ?? TimeOfDay.now();
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: initialTime,
                          );
                          if (pickedTime != null) {
                            provider.changeTime(pickedTime);
                          }
                        },
                        child: Text(
                          displayTime,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Update Event Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => provider.updateEvent(context),
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Update event",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
