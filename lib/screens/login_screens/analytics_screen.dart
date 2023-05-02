import 'package:flutter/material.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
// ignore: depend_on_referenced_packages
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:riverpod_todo_with_dashboard/services/firebase_services.dart';

import '../../component/indicator.dart';

const messagesToYou = [
  '오늘도 1day 1success 하셨나요?',
  '하루에 하나만 해도\n1년이면 365개 성공!',
  '큰 성공은 작은 시작에서부터',
  '1day 1success 기록',
  '꾸준함이 재능입니다.',
  '원하는 일은 바로 시작하세요.',
  '꿈은 이룰 수 있습니다.',
];

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // 1월부터 12월까지의 월 문자열 리스트
  static const _monthList = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  // 월별 isdone true일 수 저장용 리스트
  List<int> isDoneTrueDaysByMonth = [];

  Future<List<int>> _getIsDoneTrueDaysFromAllMonths() async {
    // 1월부터 12월까지의 isdone true일 수 가져오기
    isDoneTrueDaysByMonth = await Future.wait(List.generate(
        12,
        (index) => const FirebaseServices()
            .getIsDoneTrueDaysFromMonth(_monthList[index])));
    return isDoneTrueDaysByMonth;
  }

  final textStyle = const TextStyle(
    color: black,
    fontWeight: FontWeight.bold,
    fontFamily: 'SingleDay',
  );

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomIndex = random.nextInt(messagesToYou.length);
    final randomMessage = messagesToYou[randomIndex];

    return SafeArea(
      child: Scaffold(
        backgroundColor: indigo200,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                randomMessage,
                style: textStyle.copyWith(
                  fontSize: 30.0,
                ),
              ),
            ),
            Text(
              '올해의 통계만 볼 수 있습니다.',
              style: textStyle.copyWith(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.count(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    Card(
                      child: FutureBuilder<List<int>>(
                        future: _getIsDoneTrueDaysFromAllMonths(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                indigo200!,
                              ),
                            );
                          }
                          return BarChart(
                            BarChartData(
                              barGroups: [
                                BarChartGroupData(x: 1, barRods: [
                                  makeRodData(snapshot.data![0].toDouble())
                                ]),
                                BarChartGroupData(x: 2, barRods: [
                                  makeRodData(snapshot.data![1].toDouble())
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  makeRodData(snapshot.data![2].toDouble())
                                ]),
                                BarChartGroupData(x: 4, barRods: [
                                  makeRodData(snapshot.data![3].toDouble())
                                ]),
                                BarChartGroupData(x: 5, barRods: [
                                  makeRodData(snapshot.data![4].toDouble())
                                ]),
                                BarChartGroupData(x: 6, barRods: [
                                  makeRodData(snapshot.data![5].toDouble())
                                ]),
                                BarChartGroupData(x: 7, barRods: [
                                  makeRodData(snapshot.data![6].toDouble())
                                ]),
                                BarChartGroupData(x: 8, barRods: [
                                  makeRodData(snapshot.data![7].toDouble())
                                ]),
                                BarChartGroupData(x: 9, barRods: [
                                  makeRodData(snapshot.data![8].toDouble())
                                ]),
                                BarChartGroupData(x: 10, barRods: [
                                  makeRodData(snapshot.data![9].toDouble())
                                ]),
                                BarChartGroupData(x: 11, barRods: [
                                  makeRodData(snapshot.data![10].toDouble())
                                ]),
                                BarChartGroupData(x: 12, barRods: [
                                  makeRodData(snapshot.data![11].toDouble())
                                ]),
                              ],
                              titlesData: FlTitlesData(
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 1:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![0].toString(),
                                                  style: textStyle));
                                        case 2:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![1].toString(),
                                                  style: textStyle));
                                        case 3:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![2].toString(),
                                                  style: textStyle));
                                        case 4:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![3].toString(),
                                                  style: textStyle));
                                        case 5:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![4].toString(),
                                                  style: textStyle));
                                        case 6:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![5].toString(),
                                                  style: textStyle));
                                        case 7:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![6].toString(),
                                                  style: textStyle));
                                        case 8:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![7].toString(),
                                                  style: textStyle));
                                        case 9:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![8].toString(),
                                                  style: textStyle));
                                        case 10:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![9].toString(),
                                                  style: textStyle));
                                        case 11:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![10].toString(),
                                                  style: textStyle));
                                        case 12:
                                          return Center(
                                              child: Text(
                                                  snapshot.data![11].toString(),
                                                  style: textStyle));
                                        default:
                                          throw StateError('Not supported');
                                      }
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 40,
                                    showTitles: true,
                                    interval: 7,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 40,
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 1:
                                          return Center(
                                              child: Text('Jan',
                                                  style: textStyle));
                                        case 2:
                                          return Center(
                                              child: Text('Feb',
                                                  style: textStyle));
                                        case 3:
                                          return Center(
                                              child: Text('Mar',
                                                  style: textStyle));
                                        case 4:
                                          return Center(
                                              child: Text('Apr',
                                                  style: textStyle));
                                        case 5:
                                          return Center(
                                              child: Text('May',
                                                  style: textStyle));
                                        case 6:
                                          return Center(
                                              child: Text('Jun',
                                                  style: textStyle));
                                        case 7:
                                          return Center(
                                              child: Text('Jul',
                                                  style: textStyle));
                                        case 8:
                                          return Center(
                                              child: Text('Aug',
                                                  style: textStyle));
                                        case 9:
                                          return Center(
                                              child: Text('Sep',
                                                  style: textStyle));
                                        case 10:
                                          return Center(
                                              child: Text('Oct',
                                                  style: textStyle));
                                        case 11:
                                          return Center(
                                              child: Text('Nov',
                                                  style: textStyle));
                                        case 12:
                                          return Center(
                                              child: Text('Dec',
                                                  style: textStyle));
                                        default:
                                          throw StateError('Not supported');
                                      }
                                    },
                                  ),
                                ),
                              ),
                              //하루에 1개, 1년에 365개!
                              maxY: 31,
                              gridData: FlGridData(
                                show: false,
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder<Map<String, int>>(
                            future:
                                const FirebaseServices().getKeywordsFromYear(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    indigo200!,
                                  ),
                                );
                              }
                              return Row(
                                children: [
                                  snapshot.hasData == false ||
                                          snapshot.data == null
                                      ? Expanded(
                                          child: Center(
                                            child: Text(
                                              '키워드를 바르게 입력해 주세요.',
                                              style: textStyle.copyWith(
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          child: PieChart(
                                            PieChartData(
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 50,
                                              sections: List.generate(
                                                6,
                                                (i) {
                                                  const fontSize = 16.0;
                                                  const radius = 70.0;
                                                  switch (i) {
                                                    case 0:
                                                      return PieChartSectionData(
                                                        color: Colors.lightBlue,
                                                        value: (snapshot.data?[
                                                                    '공부'] ??
                                                                0)
                                                            .toDouble(),
                                                        title: ((snapshot
                                                                                .data?[
                                                                            '공부'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '운동'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '식단'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '업무'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '취미'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '명상'] ??
                                                                        0)) ==
                                                                0
                                                            ? '0%'
                                                            : '${((snapshot.data?['공부'] ?? 0) / ((snapshot.data?['공부'] ?? 0) + (snapshot.data?['운동'] ?? 0) + (snapshot.data?['식단'] ?? 0) + (snapshot.data?['업무'] ?? 0) + (snapshot.data?['취미'] ?? 0) + (snapshot.data?['명상'] ?? 0)) * 100).toStringAsFixed(1)}%',
                                                        radius: radius,
                                                        titleStyle:
                                                            const TextStyle(
                                                          fontSize: fontSize,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: black,
                                                        ),
                                                      );
                                                    case 1:
                                                      return PieChartSectionData(
                                                        color: Colors.orange,
                                                        value: (snapshot.data?[
                                                                    '운동'] ??
                                                                0)
                                                            .toDouble(),
                                                        title: ((snapshot
                                                                                .data?[
                                                                            '공부'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '운동'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '식단'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '업무'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '취미'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '명상'] ??
                                                                        0)) ==
                                                                0
                                                            ? '0%'
                                                            : '${((snapshot.data?['운동'] ?? 0) / ((snapshot.data?['공부'] ?? 0) + (snapshot.data?['운동'] ?? 0) + (snapshot.data?['식단'] ?? 0) + (snapshot.data?['업무'] ?? 0) + (snapshot.data?['취미'] ?? 0) + (snapshot.data?['명상'] ?? 0)) * 100).toStringAsFixed(1)}%',
                                                        radius: radius,
                                                        titleStyle:
                                                            const TextStyle(
                                                          fontSize: fontSize,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: black,
                                                        ),
                                                      );
                                                    case 2:
                                                      return PieChartSectionData(
                                                        color:
                                                            Colors.purple[300],
                                                        value: (snapshot.data?[
                                                                    '식단'] ??
                                                                0)
                                                            .toDouble(),
                                                        title: ((snapshot
                                                                                .data?[
                                                                            '공부'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '운동'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '식단'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '업무'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '취미'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '명상'] ??
                                                                        0)) ==
                                                                0
                                                            ? '0%'
                                                            : '${((snapshot.data?['식단'] ?? 0) / ((snapshot.data?['공부'] ?? 0) + (snapshot.data?['운동'] ?? 0) + (snapshot.data?['식단'] ?? 0) + (snapshot.data?['업무'] ?? 0) + (snapshot.data?['취미'] ?? 0) + (snapshot.data?['명상'] ?? 0)) * 100).toStringAsFixed(1)}%',
                                                        radius: radius,
                                                        titleStyle:
                                                            const TextStyle(
                                                          fontSize: fontSize,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: black,
                                                        ),
                                                      );
                                                    case 3:
                                                      return PieChartSectionData(
                                                        color:
                                                            Colors.indigo[300],
                                                        value: (snapshot.data?[
                                                                    '업무'] ??
                                                                0)
                                                            .toDouble(),
                                                        title: ((snapshot
                                                                                .data?[
                                                                            '공부'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '운동'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '식단'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '업무'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '취미'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '명상'] ??
                                                                        0)) ==
                                                                0
                                                            ? '0%'
                                                            : '${((snapshot.data?['업무'] ?? 0) / ((snapshot.data?['공부'] ?? 0) + (snapshot.data?['운동'] ?? 0) + (snapshot.data?['식단'] ?? 0) + (snapshot.data?['업무'] ?? 0) + (snapshot.data?['취미'] ?? 0) + (snapshot.data?['명상'] ?? 0)) * 100).toStringAsFixed(1)}%',
                                                        radius: radius,
                                                        titleStyle:
                                                            const TextStyle(
                                                          fontSize: fontSize,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: black,
                                                        ),
                                                      );
                                                    case 4:
                                                      return PieChartSectionData(
                                                        color:
                                                            Colors.amber[300],
                                                        value: (snapshot.data?[
                                                                    '취미'] ??
                                                                0)
                                                            .toDouble(),
                                                        title: ((snapshot
                                                                                .data?[
                                                                            '공부'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '운동'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '식단'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '업무'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '취미'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '명상'] ??
                                                                        0)) ==
                                                                0
                                                            ? '0%'
                                                            : '${((snapshot.data?['취미'] ?? 0) / ((snapshot.data?['공부'] ?? 0) + (snapshot.data?['운동'] ?? 0) + (snapshot.data?['식단'] ?? 0) + (snapshot.data?['업무'] ?? 0) + (snapshot.data?['취미'] ?? 0) + (snapshot.data?['명상'] ?? 0)) * 100).toStringAsFixed(1)}%',
                                                        radius: radius,
                                                        titleStyle:
                                                            const TextStyle(
                                                          fontSize: fontSize,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: black,
                                                        ),
                                                      );
                                                    case 5:
                                                      return PieChartSectionData(
                                                        color: Colors.teal[300],
                                                        value: (snapshot.data?[
                                                                    '명상'] ??
                                                                0)
                                                            .toDouble(),
                                                        title: ((snapshot
                                                                                .data?[
                                                                            '공부'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '운동'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '식단'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '업무'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '취미'] ??
                                                                        0) +
                                                                    (snapshot.data?[
                                                                            '명상'] ??
                                                                        0)) ==
                                                                0
                                                            ? '0%'
                                                            : '${((snapshot.data?['명상'] ?? 0) / ((snapshot.data?['공부'] ?? 0) + (snapshot.data?['운동'] ?? 0) + (snapshot.data?['식단'] ?? 0) + (snapshot.data?['업무'] ?? 0) + (snapshot.data?['취미'] ?? 0) + (snapshot.data?['명상'] ?? 0)) * 100).toStringAsFixed(1)}%',
                                                        radius: radius,
                                                        titleStyle:
                                                            const TextStyle(
                                                          fontSize: fontSize,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: black,
                                                        ),
                                                      );
                                                    default:
                                                      throw Error();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const <Widget>[
                                      Indicator(
                                        color: Colors.lightBlue,
                                        text: '공부',
                                        isSquare: true,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Indicator(
                                        color: Colors.orange,
                                        text: '운동',
                                        isSquare: true,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Indicator(
                                        color: Colors.purple,
                                        text: '식단',
                                        isSquare: true,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Indicator(
                                        color: Colors.indigo,
                                        text: '업무',
                                        isSquare: true,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Indicator(
                                        color: Colors.amber,
                                        text: '취미',
                                        isSquare: true,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Indicator(
                                        color: Colors.teal,
                                        text: '명상',
                                        isSquare: true,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BarChartRodData makeRodData(double y) {
  return BarChartRodData(
    toY: y,
    gradient: const LinearGradient(
      colors: [
        Color(0xFFFFD336),
        Color(0xFFFFAB5E),
      ],
    ),
    width: 14,
    borderRadius: BorderRadius.circular(2),
    backDrawRodData: BackgroundBarChartRodData(
      show: true,
      color: const Color(0xFFFCFCFC),
      fromY: 31,
    ),
  );
}

// List<PieChartSectionData> showingSections() {
//   return List.generate(6, (i) {
//     const fontSize = 16.0;
//     const radius = 70.0;

//     switch (i) {
//       case 0:
//         return PieChartSectionData(
//           color: Colors.lightBlue,
//           value: 40,
//           title: '공부',
//           radius: radius,
//           titleStyle: const TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//             color: black,
//           ),
//         );
//       case 1:
//         return PieChartSectionData(
//           color: Colors.orange,
//           value: 30,
//           title: '운동',
//           radius: radius,
//           titleStyle: const TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//             color: black,
//           ),
//         );
//       case 2:
//         return PieChartSectionData(
//           color: Colors.purple[300],
//           value: 15,
//           title: '식단',
//           radius: radius,
//           titleStyle: const TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//             color: black,
//           ),
//         );
//       case 3:
//         return PieChartSectionData(
//           color: Colors.indigo[300],
//           value: 15,
//           title: '업무',
//           radius: radius,
//           titleStyle: const TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//             color: black,
//           ),
//         );
//       case 4:
//         return PieChartSectionData(
//           color: Colors.amber[300],
//           value: 15,
//           title: '취미',
//           radius: radius,
//           titleStyle: const TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//             color: black,
//           ),
//         );
//       case 5:
//         return PieChartSectionData(
//           color: Colors.teal[300],
//           value: 15,
//           title: '명상',
//           radius: radius,
//           titleStyle: const TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//             color: black,
//           ),
//         );
//       default:
//         throw Error();
//     }
//   });
// }
