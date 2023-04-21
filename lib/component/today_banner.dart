import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:riverpod_todo_with_dashboard/database/drift_database.dart';
import 'package:riverpod_todo_with_dashboard/model/schedule_with_emoji.dart';

// ignore: must_be_immutable
class TodayBanner extends StatefulWidget {
  late DateTime? selectedDay;
  late DateTime? focusedDay;

  TodayBanner({
    required this.selectedDay,
    required this.focusedDay,
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
                  //TODO: 2번 오늘로 돌아가기 버튼 기능 구현
                  //오늘로 돌아가기를 눌렀을 때
                  //왼쪽 칸 날짜와 캘린더에서
                  //내용이 오늘자로 변경되어야 한다.
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
              child: StreamBuilder<List<ScheduleWithEmoji>>(
                  stream: GetIt.I<LocalDatabase>()
                      .watchSchedules(widget.selectedDay!),
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
