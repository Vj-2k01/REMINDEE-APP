import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:remindee/analysis_page.dart';
import 'package:remindee/reminder.dart';
import 'package:remindee/reminders_page.dart';
import 'package:remindee/wellness_tips.dart';

class Remindee extends StatefulWidget {
  int? refIndex;
  Remindee({this.refIndex, super.key});

  @override
  State<Remindee> createState() => _RemindeeState();
}

class _RemindeeState extends State<Remindee> {
  int _pageIndex = 0;

  @override
  void initState() {
    if (widget.refIndex != null) {
      _pageIndex = widget.refIndex!;
      setState(() {});
    }
    super.initState();
  }

  final _pages = [
    const HomePage(),
    const ReminderListPage(),
    const AppList(),
    const WellnessTipsPage()
  ];
  List<Color> iconColor = [
    Colors.white,
    Colors.black,
    Colors.black,
    Colors.black
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: [
          Icon(Icons.home_outlined, size: 30, color: iconColor[0]),
          Icon(
            Icons.alarm_outlined,
            color: iconColor[1],
            size: 30,
          ),
          Icon(
            Icons.stacked_line_chart_outlined,
            color: iconColor[2],
            size: 30,
          ),
          Icon(
            Icons.lightbulb_outlined,
            color: iconColor[3],
            size: 30,
          ),
        ],
        color: Colors.grey.shade300,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (int tappedIndex) {
          setState(() {
            _pageIndex = tappedIndex;
            iconColor = [
              Colors.black,
              Colors.black,
              Colors.black,
              Colors.black
            ];
            iconColor[tappedIndex] = Colors.white;
          });
        },
      ),
    );
  }
}
