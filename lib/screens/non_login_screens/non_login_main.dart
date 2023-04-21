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
  DateTime selectedDay = DateTime.utc(
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
            _ScheduleList(
              selectedDate: selectedDay,
            ),
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
  final DateTime selectedDate;

  const _ScheduleList({required this.selectedDate, Key? key}) : super(key: key);

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
              print('---original data---');
              print(snapshot.data);

              List<Schedule> schedules = [];

              if (snapshot.hasData) {
                schedules = snapshot.data!
                    .where((element) => element.date.toUtc() == selectedDate)
                    .toList();

                print('---filtered data---');
                print(selectedDate);
                print(schedules);
              }

              return ListView.separated(
                itemCount: schedules.length,
                separatorBuilder: (context, builder) {
                  return const SizedBox(
                    height: 8.0,
                  );
                },
                itemBuilder: (context, index) {
                  final schedule = schedules[index];

                  return ScheduleCard(
                    startTime: schedule.startTime,
                    endTime: schedule.endTime,
                    content: schedule.content,
                    //나중에 emoji 테이블이랑 조인해서 데이터 가져 와야 하는 부분
                    color: Colors.red,
                  );
                },
              );
            }),
      ),
    );
  }
}
