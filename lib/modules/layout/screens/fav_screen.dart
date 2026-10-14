import 'package:flutter/material.dart';

import '../../../core/models/event_model.dart';
import '../../../core/services/db_service.dart';
import '../widgets/event_widget.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder(
              future: DbService.getFavEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: theme.textTheme.titleMedium,
                    ),
                  );
                } else {
                  List<EventModel> events = snapshot.data ?? [];
                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return EventWidget(
                          event: events[index],
                          onTapFav: () async {
                            await DbService.toggleFav(events[index]);
                            setState(() {});
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: events.length,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
