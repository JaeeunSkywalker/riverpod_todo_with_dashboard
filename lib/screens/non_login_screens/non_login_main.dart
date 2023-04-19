import 'package:flutter/material.dart';
import 'package:riverpod_todo_with_dashboard/component/calendar.dart';
import 'package:riverpod_todo_with_dashboard/component/today_banner.dart';

class NonLoginMain extends StatefulWidget {
  const NonLoginMain({super.key});

  @override
  State<NonLoginMain> createState() => _NonLoginMainState();
}

class _NonLoginMainState extends State<NonLoginMain> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: OnDaySelected,
            ),
            const SizedBox(
              height: 8.0,
            ),
            TodayBanner(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              scheduleCount: 3,
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void OnDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(
      () {
        this.selectedDay = selectedDay;
        this.focusedDay = selectedDay;
      },
    );
  }
}
