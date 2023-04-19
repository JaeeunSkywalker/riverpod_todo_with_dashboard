import 'package:flutter/material.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:riverpod_todo_with_dashboard/screens/non_login_screens/non_login_main.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class TodayBanner extends StatefulWidget {
  late DateTime? selectedDay;
  late DateTime? focusedDay;
  final int scheduleCount;

  TodayBanner({
    required this.selectedDay,
    required this.focusedDay,
    required this.scheduleCount,
    Key? key,
  }) : super(key: key);

  @override
  State<TodayBanner> createState() => _TodayBannerState();
}

class _TodayBannerState extends State<TodayBanner> {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: white,
    );

    return Container(
      color: CalendarPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                textAlign: TextAlign.start,
                '${widget.selectedDay!.year}년 ${widget.selectedDay!.month}월 ${widget.selectedDay!.day}일',
                style: textStyle,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  widget.selectedDay = DateTime.now();
                  //TODO: 2번
                  //오늘로 돌아가기를 눌렀을 때 캘린더에서도 포커스가 오늘로 변경되어야 한다.
                });
              },
              child: const Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  '오늘로 돌아가기',
                  style: textStyle,
                ),
              ),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                '${widget.scheduleCount}개',
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
