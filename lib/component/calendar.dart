import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:riverpod_todo_with_dashboard/database/drift_database.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class Calendar extends StatelessWidget {
  //지금 내가 누른 거
  final DateTime? selectedDay;
  //보여줄 캘린더 월의 기준
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  final DateTime today = DateTime.now();

  Calendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    Key? key,
  }) : super(key: key);

  // ignore: non_constant_identifier_names
  final DefaultBoxDeco = BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(6.0),
  );

  // ignore: non_constant_identifier_names
  final DefaultTextStyle = TextStyle(
    color: Colors.grey[600],
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Schedule>>(
        future: GetIt.I<LocalDatabase>().getSchedules(),
        builder: (context, snapshot) {
          List<Schedule> schedules = snapshot.data ?? [];
          // ignore: avoid_print
          // print('---기본---');
          // ignore: avoid_print
          // print(schedules); // null일 때 빈 리스트로 초기화
          // List<Schedule> filteredSchedules = schedules
          //     .where((element) => element.date.month == selectedDay!.month)
          //     .toList();
          // ignore: avoid_print
          // print('---필터링 후---');
          // ignore: avoid_print
          // print(filteredSchedules); // null일 때 빈 리스트로 초기화

          return TableCalendar(
            //locale: 'ko_KR',
            focusedDay: focusedDay,
            firstDay: DateTime(2023),
            lastDay: DateTime(2033),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
              ),
            ),
            currentDay: today,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: false,
              defaultDecoration: DefaultBoxDeco,
              weekendDecoration: DefaultBoxDeco,
              selectedDecoration: BoxDecoration(
                color: Colors.indigo[200],
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: black,
                  width: 1.0,
                ),
              ),
              outsideDecoration: const BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              defaultTextStyle: DefaultTextStyle,
              weekendTextStyle: DefaultTextStyle,
              selectedTextStyle: DefaultTextStyle.copyWith(
                color: white,
              ),
            ),

            onDaySelected: onDaySelected,

            selectedDayPredicate: (DateTime date) {
              if (selectedDay == null) {
                return false;
              }

              return date.year == selectedDay!.year &&
                      date.month == selectedDay!.month &&
                      date.day == selectedDay!.day ||
                  schedules
                      .map((e) =>
                          e.date.year == date.year &&
                          e.date.month == date.month &&
                          e.date.day == date.day)
                      .contains(true);
            },
          );
        });
  }
}
