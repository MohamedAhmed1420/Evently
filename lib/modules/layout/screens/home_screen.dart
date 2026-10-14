import 'package:evently/core/app_provider/app_provider.dart';
import 'package:evently/core/constante/app_category.dart';
import 'package:evently/core/models/event_model.dart';
import 'package:evently/core/services/db_service.dart';
import 'package:evently/modules/layout/widgets/event_widget.dart';
import 'package:evently/modules/layout/widgets/tab_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;
    var theme = Theme.of(context);
    var provider = Provider.of<AppProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Welcome message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back ✨",
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.displayName ?? "",
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),

                Image.asset(
                  provider.themeMode == ThemeMode.dark
                      ? "assets/icons/moon.png"
                      : "assets/icons/sun.png",
                  color: theme.primaryColor,
                  width: 26,
                  height: 26,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    provider.locale.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            DefaultTabController(
              length: AppCategory.categories.length + 1,
              child: TabBar(
                dividerColor: Colors.transparent,
                indicator: const BoxDecoration(color: Colors.transparent),
                isScrollable: true,
                onTap: (value) {
                  index = value;
                  setState(() {});
                },
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.all(8),
                tabs: [
                  TabWidget(
                    category: AppCategory(
                      iconData: Icons.menu,
                      id: "all",
                      name: "All",
                      image: "",
                    ),
                    isSelected: index == 0,
                  ),
                  ...AppCategory.categories.map((e) {
                    int categoryIndex = AppCategory.categories.indexOf(e) + 1;
                    return TabWidget(
                      category: e,
                      isSelected: index == categoryIndex,
                    );
                  }),
                ],
              ),
            ),

            StreamBuilder(
              stream: DbService.getEventsStream(
                index == 0 ? null : AppCategory.categories[index - 1].id,
              ),
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
                  List<EventModel> events = [];
                  for (var e in snapshot.data!.docs) {
                    var event = EventModel.fromJson(e.data());
                    events.add(event);
                  }
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
            ),

            // FutureBuilder(
            //   future: DbService.getEvents(index == 0? null : AppCategory.categories[index-1].id ),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(child: CircularProgressIndicator());
            //     } else if (snapshot.hasError) {
            //       return Center(child: Text(snapshot.error.toString()));
            //     } else {
            //       List<EventModel> events = snapshot.data ?? [];
            //       return Expanded(
            //         child: ListView.separated(
            //           itemBuilder: (context, index) {
            //             return EventWidget(event: events[index],onTapFav: ()async {
            //              await DbService.toggleFav(events[index]);
            //              setState(() {
            //
            //              });
            //             },);
            //           },
            //           separatorBuilder: (context, index) => SizedBox(height: 8),
            //           itemCount: events.length,
            //         ),
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
