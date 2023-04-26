import 'package:flutter/material.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
// ignore: depend_on_referenced_packages
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

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
  //서버에서 데이터 받아 와서 저장
  final double janTodos = 0;
  final double febTodos = 0;
  final double marTodos = 0;
  final double aprTodos = 0;
  final double mayTodos = 0;
  final double junTodos = 0;
  final double julTodos = 0;
  final double augTodos = 0;
  final double sepTodos = 0;
  final double octTodos = 0;
  final double novTodos = 0;
  final double decTodos = 0;

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
              padding: const EdgeInsets.all(30.0),
              child: Text(
                randomMessage,
                style: textStyle.copyWith(
                  fontSize: 25.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '올 해의 통계만 볼 수 있습니다.',
                style: textStyle.copyWith(
                  fontSize: 25.0,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 1,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  Card(
                    child: BarChart(
                      BarChartData(
                        barGroups: [
                          BarChartGroupData(
                              x: 1, barRods: [makeRodData(janTodos)]),
                          BarChartGroupData(
                              x: 2, barRods: [makeRodData(febTodos)]),
                          BarChartGroupData(
                              x: 3, barRods: [makeRodData(marTodos)]),
                          BarChartGroupData(
                              x: 4, barRods: [makeRodData(aprTodos)]),
                          BarChartGroupData(
                              x: 5, barRods: [makeRodData(mayTodos)]),
                          BarChartGroupData(
                              x: 6, barRods: [makeRodData(junTodos)]),
                          BarChartGroupData(
                              x: 7, barRods: [makeRodData(julTodos)]),
                          BarChartGroupData(
                              x: 8, barRods: [makeRodData(octTodos)]),
                          BarChartGroupData(
                              x: 9, barRods: [makeRodData(sepTodos)]),
                          BarChartGroupData(
                              x: 10, barRods: [makeRodData(octTodos)]),
                          BarChartGroupData(
                              x: 11, barRods: [makeRodData(novTodos)]),
                          BarChartGroupData(
                              x: 12, barRods: [makeRodData(decTodos)]),
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
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 40,
                              showTitles: true,
                              interval: 31,
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
                                        child: Text('Jan', style: textStyle));
                                  case 2:
                                    return Center(
                                        child: Text('Feb', style: textStyle));
                                  case 3:
                                    return Center(
                                        child: Text('Mar', style: textStyle));
                                  case 4:
                                    return Center(
                                        child: Text('Apr', style: textStyle));
                                  case 5:
                                    return Center(
                                        child: Text('May', style: textStyle));
                                  case 6:
                                    return Center(
                                        child: Text('Jun', style: textStyle));
                                  case 7:
                                    return Center(
                                        child: Text('Jul', style: textStyle));
                                  case 8:
                                    return Center(
                                        child: Text('Aug', style: textStyle));
                                  case 9:
                                    return Center(
                                        child: Text('Sep', style: textStyle));
                                  case 10:
                                    return Center(
                                        child: Text('Oct', style: textStyle));
                                  case 11:
                                    return Center(
                                        child: Text('Nov', style: textStyle));
                                  case 12:
                                    return Center(
                                        child: Text('Dec', style: textStyle));
                                  default:
                                    throw StateError('Not supported');
                                }
                              },
                            ),
                          ),
                        ),
                        //하루에 1개, 1년에 365개!
                        maxY: 365,
                        gridData: FlGridData(
                          show: false,
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                      ),
                    ),
                    //const Card(),
                  ),
                ],
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
      fromY: 365,
    ),
  );
}
