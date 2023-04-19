import 'package:flutter/material.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class Calendar extends StatelessWidget {
  //지금 내가 누른 거
  final DateTime? selectedDay;
  //보여줄 캘린더 월의 기준
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  Calendar(
      {required this.selectedDay,
      required this.focusedDay,
      required this.onDaySelected,
      super.key});
  final defaultBoxDeco = BoxDecoration(
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
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: defaultBoxDeco,
        weekendDecoration: defaultBoxDeco,
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
            date.day == selectedDay!.day;
      },
    );
  }
}
