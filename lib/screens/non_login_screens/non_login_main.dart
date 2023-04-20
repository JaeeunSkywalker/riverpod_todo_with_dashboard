import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_todo_with_dashboard/component/calendar.dart';
import 'package:riverpod_todo_with_dashboard/component/schedule_bottom_sheet.dart';
import 'package:riverpod_todo_with_dashboard/component/schedule_card.dart';
import 'package:riverpod_todo_with_dashboard/component/today_banner.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';

import '../../database/drift_database.dart';

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
        floatingActionButton: renderFloatingActionButton(),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.56,
              child: Calendar(
                selectedDay: selectedDay,
                focusedDay: focusedDay,
                onDaySelected: OnDaySelected,
              ),
            ),
            TodayBanner(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              scheduleCount: 3,
            ),
            const SizedBox(
              height: 8.0,
            ),
            const _ScheduleList(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: CalendarPrimaryColor,
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) {
            return ScheduleBottomSheet(
              selectedDate: selectedDay,
            );
          },
        );
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  OnDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(
      () {
        this.selectedDay = selectedDay;
        this.focusedDay = selectedDay;
      },
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 8.0,
        ),
        child: StreamBuilder<List<Schedule>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(),
            builder: (context, snapshot) {
              print(snapshot.data);
              return ListView.separated(
                itemCount: 10,
                separatorBuilder: (context, builder) {
                  return const SizedBox(
                    height: 8.0,
                  );
                },
                itemBuilder: (context, index) {
                  return const ScheduleCard(
                    startTime: 8,
                    endTime: 14,
                    content: '프로그래밍 공부하기',
                    color: Colors.red,
                  );
                },
              );
            }),
      ),
    );
  }
}
