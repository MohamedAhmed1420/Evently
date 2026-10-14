import 'package:evently/core/constante/app_category.dart';
import 'package:evently/core/models/event_model.dart';
import 'package:evently/core/services/db_service.dart';
import 'package:evently/modules/edit_eventl_screen/screen/edit_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DescScreen extends StatelessWidget {
  static const String routeName = "DescScreen";

  const DescScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // Get the event model passed via navigation arguments
    var event = ModalRoute.of(context)!.settings.arguments as EventModel;

    // Find the category corresponding to event.categoryId
    var category = AppCategory.categories.firstWhere(
      (element) => element.id == event.categoryId,
      orElse: () => AppCategory.categories.first,
    );

    String formattedDate = event.date;
    if (event.date.isNotEmpty) {
      DateTime? parsed = DateTime.tryParse(event.date);
      if (parsed != null) {
        formattedDate = DateFormat.yMd().format(parsed);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event details",
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
        actions: [
          Row(
            children: [
              // Edit button
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    EditEvent.routeName,
                    arguments: event,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.primaryColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: ImageIcon(
                    const AssetImage("assets/icons/edit.png"),
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Delete button
              InkWell(
                onTap: () async {
                  try {
                    await DbService.deleteEvent(event.id);

                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Event deleted successfully'),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete event: $e'),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const ImageIcon(
                    AssetImage("assets/icons/trash.png"),
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                category.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.event, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Event title
            Text(
              event.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),

            // Date & Time Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.primaryColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.time,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Event description header
            Text(
              "Description",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),

            // Event description content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                event.desc,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
