import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_todo_with_dashboard/component/offline_calendar.dart';
import 'package:riverpod_todo_with_dashboard/component/schedule_bottom_sheet.dart';
import 'package:riverpod_todo_with_dashboard/component/schedule_card.dart';
import 'package:riverpod_todo_with_dashboard/component/today_banner.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:riverpod_todo_with_dashboard/model/schedule_with_emoji.dart';

import '../database/drift_database.dart';

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
              onGoToToday: goToToday, // 콜백 함수 전달
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: _ScheduleList(
                selectedDate: selectedDay,
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: indigo200,
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

  void goToToday() {
    setState(() {
      // 왼쪽 칸 날짜와 캘린더에서 내용이 오늘자로 변경되어야 한다.
      selectedDay = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      focusedDay = DateTime.now(); // focusedDay를 현재 날짜로 변경
    });
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDate;

  const _ScheduleList({required this.selectedDate, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: StreamBuilder<List<ScheduleWithEmoji>>(
          stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    indigo200!,
                  ),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text('스케줄이 없습니다.'),
              );
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, builder) {
                return const SizedBox(
                  height: 8.0,
                );
              },
              itemBuilder: (context, index) {
                final scheduleWithEmoji = snapshot.data![index];

                return Dismissible(
                  key: ObjectKey(scheduleWithEmoji.schedule.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (DismissDirection direction) {
                    GetIt.I<LocalDatabase>()
                        .removeSchedule(scheduleWithEmoji.schedule.id);
                  },
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return ScheduleBottomSheet(
                            selectedDate: selectedDate,
                            scheduleId: scheduleWithEmoji.schedule.id,
                          );
                        },
                      );
                    },
                    child: ScheduleCard(
                      startTime: scheduleWithEmoji.schedule.startTime,
                      endTime: scheduleWithEmoji.schedule.endTime,
                      content: scheduleWithEmoji.schedule.content,
                      //나중에 emoji 테이블이랑 조인해서 데이터 가져 와야 하는 부분
                      emoji: scheduleWithEmoji.categoryEmoji.hexCode,
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
