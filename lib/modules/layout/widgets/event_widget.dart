import 'package:evently/core/constante/app_category.dart';
import 'package:evently/core/models/event_model.dart';
import 'package:evently/modules/layout/screens/desc_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventWidget extends StatelessWidget {
  final EventModel event;
  final Function onTapFav;

  const EventWidget({super.key, required this.event, required this.onTapFav});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var category = AppCategory.categories.firstWhere((element) {
      return element.id == event.categoryId;
    });
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DescScreen.routeName, arguments: event);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(category.image),
            fit: BoxFit.cover,

          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(event.time, style: theme.textTheme.titleMedium),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(event.title, style: theme.textTheme.titleLarge),
                  ),
                  InkWell(
                    onTap: () {
                      onTapFav();
                    },
                    child: Icon(
                      event.usersFav.contains(
                            FirebaseAuth.instance.currentUser!.uid,
                          )
                          ? Icons.favorite_rounded
                          : Icons.favorite_border,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
