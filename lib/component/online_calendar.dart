import 'package:flutter/material.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:table_calendar/table_calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class Calendar extends StatelessWidget {
  //지금 내가 누른 거
  final DateTime? selectedDay;
  //보여줄 캘린더 월의 기준
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  //final DateTime today = DateTime.now();

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

  Future<List<String>>? fetchDataFromFirebaseForCalendar() async {
    final List<String> data = [];

    try {
      //db instance 만들고
      final db = FirebaseFirestore.instance;

      //uid 받고
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final QuerySnapshot datesSnapshot =
          await db.collection('users').doc(uid).collection('dates').get();

      if (datesSnapshot.docs.isEmpty) {
        // ignore: avoid_print
        // print('datesSnapshot.docs is empty');
      } else {
        //각 날짜별 문서에 접근 중
        for (final dateDoc in datesSnapshot.docs) {
          // 각각의 dateDoc은 dates 컬렉션 아래의 한 문서를 나타냅니다.
          final String date = dateDoc.id;

          // 해당 날짜 문서에 속한 indexes 서브콜렉션 가져오기
          final QuerySnapshot indexesSnapshot = await db
              .collection('users')
              .doc(uid)
              .collection('dates')
              .doc(date)
              .collection('indexes')
              .get();

          for (final indexDoc in indexesSnapshot.docs) {
            // 각각의 indexDoc은 해당 날짜의 indexes 서브콜렉션에 속한 한 문서를 나타냅니다.
            final String index = indexDoc.id;
            // index 문서에서 필요한 데이터 가져오기
            // final String title = indexDoc.get('title');
            // final String selectedTime = indexDoc.get('selectedTime');
            // final String content = indexDoc.get('content');
            // 가져온 데이터를 사용하여 필요한 작업 수행
            // 가져온 데이터를 data 리스트에 추가

            data.add('$date,$index');
          }
        }
      }
      return data;
    } catch (e) {
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: fetchDataFromFirebaseForCalendar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  indigo200!,
                ),
              ),
            );
          }
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
              // todayTextStyle: DefaultTextStyle.copyWith(
              //   color: red,
              // ),
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

              for (var todo in snapshot.data!) {
                if (todo.split(',').first ==
                    '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}') {
                  return true;
                }
              }

              return false;
            },
          );
        });
  }
}
