import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:riverpod_todo_with_dashboard/database/drift_database.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class OfflineCalendar extends StatelessWidget {
  //지금 내가 누른 거
  final DateTime? selectedDay;
  //보여줄 캘린더 월의 기준
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  //final DateTime today = DateTime.now();

  OfflineCalendar({
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
    return Padding(
      padding: const EdgeInsets.only(
        top: 22.0,
      ),
      child: FutureBuilder<List<Schedule>>(
          future: GetIt.I<LocalDatabase>().getSchedules(),
          builder: (context, snapshot) {
            List<Schedule> schedules = snapshot.data ?? [];
            return TableCalendar(
              daysOfWeekHeight: 40.0,
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
              //currentDay: today,
              calendarStyle: CalendarStyle(
                //isTodayHighlighted: true,
                defaultDecoration: DefaultBoxDeco,
                weekendDecoration: DefaultBoxDeco,
                selectedDecoration: BoxDecoration(
                  color: indigo200,
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

                if (date.year == selectedDay!.year &&
                    date.month == selectedDay!.month &&
                    date.day == selectedDay!.day) {
                  return true;
                }

                if (date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day) {
                  return true;
                }

                for (var schedule in schedules) {
                  if (schedule.date.year == date.year &&
                      schedule.date.month == date.month &&
                      schedule.date.day == date.day) {
                    return true;
                  }
                }

                return false;
              },
            );
          }),
    );
  }
}
