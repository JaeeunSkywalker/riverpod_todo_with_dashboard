import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:riverpod_todo_with_dashboard/database/drift_database.dart';
import 'package:riverpod_todo_with_dashboard/model/schedule_with_emoji.dart';

// ignore: must_be_immutable
class TodayBanner extends StatefulWidget {
  DateTime selectedDay;
  DateTime focusedDay;
  final void Function() onGoToToday; // 콜백 함수 타입 정의

  TodayBanner({
    required this.selectedDay,
    required this.focusedDay,
    required this.onGoToToday, // 콜백 함수 매개변수 추가
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
      color: indigo200,
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
                '${widget.selectedDay.year}년 ${widget.selectedDay.month}월 ${widget.selectedDay.day}일',
                style: textStyle,
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: widget.onGoToToday,
                child: const Text(
                  textAlign: TextAlign.center,
                  '오늘로 돌아가기',
                  style: textStyle,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ScheduleWithEmoji>>(
                  stream: GetIt.I<LocalDatabase>()
                      .watchSchedules(widget.selectedDay),
                  builder: (context, snapshot) {
                    int count = 0;
                    if (snapshot.hasData) {
                      count = snapshot.data!.length;
                    }
                    return Text(
                      textAlign: TextAlign.end,
                      '$count개',
                      style: textStyle,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
