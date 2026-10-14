import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constante/app_category.dart';
import '../../layout/widgets/tab_widget.dart';
import '../manager/event_manager.dart';

class AddEventScreen extends StatelessWidget {
  static const String routeName = "AddEventScreen";
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // Instantiate provider at the top level so context works everywhere inside Scaffold
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Add Event")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<EventProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Preview Image
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

                  // Category Selector Tabs
                  DefaultTabController(
                    length: AppCategory.categories.length,
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(color: Colors.transparent),
                      isScrollable: true,
                      onTap: (value) => provider.changeIndex(value),
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.all(8),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: AppCategory.categories.map((category) {
                        int categoryIndex = AppCategory.categories.indexOf(category);
                        return TabWidget(
                          category: category,
                          isSelected: provider.index == categoryIndex,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title Input
                  Text("Title", style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: provider.titleController,
                    decoration: const InputDecoration(hintText: "Event Title"),
                  ),
                  const SizedBox(height: 16),

                  // Description Input
                  Text("Description", style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: TextFormField(
                      controller: provider.descController,
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
                      Icon(Icons.date_range, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text("Event Date", style: theme.textTheme.titleLarge),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          DateTime initialDate = provider.selectedDateTime ?? DateTime.now();
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            provider.changeDate(pickedDate);
                          }
                        },
                        child: Text(
                          provider.selectedDateTime == null
                              ? "Choose Date"
                              : DateFormat.yMd().format(provider.selectedDateTime!),
                          style: theme.textTheme.titleMedium!.copyWith(
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
                      Text("Event Time", style: theme.textTheme.titleLarge),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay initialTime = provider.selectedTime ?? TimeOfDay.now();
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: initialTime,
                          );
                          if (pickedTime != null) {
                            provider.changeTime(pickedTime);
                          }
                        },
                        child: Text(
                          provider.selectedTime == null
                              ? "Choose Time"
                              : provider.selectedTime!.format(context),
                          style: theme.textTheme.titleMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Add Event Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () {
                              provider.addEvent(context);
                            },
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Add Event"),
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
