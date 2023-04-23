import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../component/calendar.dart';
import '../component/schedule_bottom_sheet.dart';
import '../component/schedule_card.dart';
import '../component/today_banner.dart';
import '../consts/colors.dart';
import '../database/drift_database.dart';
import '../model/schedule_with_emoji.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? displayName = FirebaseAuth.instance.currentUser?.displayName;
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => const ExitAlertDialog(),
            )) ??
            false;
      },
      child: SafeArea(
        child: Scaffold(
            floatingActionButton: renderFloatingActionButton(),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      style: const TextStyle(
                        fontFamily: 'SingleDay',
                        fontSize: 22.0,
                      ),
                      displayName != null
                          ? '$displayName님, 오늘도 화이팅!'
                          : '오늘도 화이팅!!!',
                    ),
                    MaterialButton(
                      padding: const EdgeInsets.all(5),
                      color: Colors.indigo[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        'LOG OUT',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: () {
                        AuthService().signOut();
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    //월에 따라 이모지 다르게 표현하기
                    //'🎆☃️🏫🌷👨‍👩‍👧‍👦🍱🎰🏖️🎑🎃☕🎄',
                    Text(
                      style: TextStyle(
                        fontSize: 80.0,
                      ),
                      '🥇',
                    ),
                  ],
                ),
                //이 밑으로 캘린더
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
                _ScheduleList(
                  selectedDate: selectedDay,
                ),
              ],
            )),
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

class ExitAlertDialog extends StatelessWidget {
  const ExitAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('앱 종료'),
      content: const Text('앱을 종료하시겠습니까?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('종료'),
        ),
      ],
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
        child: StreamBuilder<List<ScheduleWithEmoji>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
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
      ),
    );
  }
}
