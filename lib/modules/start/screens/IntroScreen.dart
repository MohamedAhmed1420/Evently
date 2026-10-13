import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/modules/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/IntroData.dart';

class IntroScreen extends StatefulWidget {
  static const String routeName = "introScreen";

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var local = AppLocalizations.of(context)!;
    bool isDark = theme.brightness == Brightness.dark;
    final List<IntroData> introList = [
      IntroData(
        imagePath: 'assets/images/intro1.png',
        title: local.titleStart1,
        subTitle: local.desStart1,
      ),
      IntroData(
        imagePath: 'assets/images/intro2.png',
        title: local.titleStart2,
        subTitle: local.desStart2,
      ),
      IntroData(
        imagePath: 'assets/images/intro3.png',
        title: local.titleStart3,
        subTitle: local.desStart3,
      ),
    ];

    bool isLastPage = _currentPage == introList.length - 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF003399),
                ),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : const SizedBox.shrink(),
        title: Image.asset(
          'assets/logo/app_logo.png',
          height: 24,
          color: theme.primaryColor,
        ),
        actions: [
          if (!isLastPage)
            InkWell(
              onTap: () {
                _pageController.animateToPage(
                  introList.length - 1, // إصلاح التمرير لآخر صفحة
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  color: isDark
                      ? theme.primaryColor
                      : theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  local.skip,
                  style: TextStyle(
                    color: isDark ? Colors.white : theme.primaryColorLight,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: introList.length,
                  itemBuilder: (context, index) {
                    final item = introList[index];
                    return Column(
                      children: [
                        // Illustration Image
                        Expanded(
                          flex: 5,
                          child: Image.asset(
                            item.imagePath,
                            color: theme.primaryColorLight,
                          ),
                        ),

                        const SizedBox(height: 16),

                        //Animated Page Indicators (Dots)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            introList.length,
                            (dotIndex) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              height: 8,
                              width: _currentPage == dotIndex ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == dotIndex
                                    ? const Color(0xFF003399)
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Title & Subtitle Section
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.subTitle,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Bottom Primary Action Button (Next / Get Started)
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    if (isLastPage) {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Center(
                    child: Text(
                      isLastPage
                          ? (local.letsStart ?? "Let's Start")
                          : local.next,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
