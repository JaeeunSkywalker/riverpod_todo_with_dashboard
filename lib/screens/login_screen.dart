import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_todo_with_dashboard/screens/login_screens/analytics_screen.dart';
import 'package:riverpod_todo_with_dashboard/screens/login_screens/on_day_selected_page.dart';
import 'package:riverpod_todo_with_dashboard/database/drift_database.dart';

import '../component/online_calendar.dart';
import '../consts/colors.dart';
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
            body: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
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
                    padding: const EdgeInsets.all(7.0),
                    color: indigo200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      '로그아웃',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    onPressed: () {
                      AuthService().signOut();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: FutureBuilder<List<CategoryMonthEmoji>>(
                future: GetIt.I<LocalDatabase>().getCategoryMonthEmojis(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final selectedMonthEmojiIndex = focusedDay.month - 1;
                    final selectedMonthEmoji =
                        snapshot.data![selectedMonthEmojiIndex];
                    return Text(
                      selectedMonthEmoji.hexCode,
                      style: const TextStyle(
                        fontSize: 70,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        indigo200!,
                      ),
                    );
                  }
                },
              ),
            ),
            //이 밑으로 캘린더
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.58,
                child: OnlineCalendar(
                  selectedDay: selectedDay,
                  focusedDay: focusedDay,
                  onDaySelected: OnDaySelected,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: TodayBanner(
                onGoToToday: goToToday, // 콜백 함수 전달
              ),
            ),
          ],
        )),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  OnDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(
      () {
        this.selectedDay = selectedDay;
        this.focusedDay = selectedDay;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnDaySelectedPage(
              selectedDay: selectedDay,
            ),
          ),
        );
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
      title: const Text(
        '앱 종료',
        style: TextStyle(
          color: black,
        ),
      ),
      content: const Text(
        '앱을 종료하시겠습니까?',
        style: TextStyle(
          color: black,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            '취소',
            style: TextStyle(
              color: black,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            '종료',
            style: TextStyle(
              color: black,
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class TodayBanner extends StatefulWidget {
  final void Function() onGoToToday; // 콜백 함수 타입 정의

  const TodayBanner({
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
      height: 100,
      color: indigo200,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnalyticsScreen(),
                    ),
                  );
                }, // 콜백 함수 호출
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '활동 내역 리포트 보기',
                    style: textStyle,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: widget.onGoToToday, // 콜백 함수 호출
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '오늘로 돌아가기',
                    style: textStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
