import 'package:evently/core/constante/app_category.dart';
import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  final bool isSelected;
  final AppCategory category;

  const TabWidget({
    super.key,
    required this.category,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Tab(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.primaryColorDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.primaryColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              category.iconData,
              color: isSelected ? Colors.white : theme.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected ? Colors.white : theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
