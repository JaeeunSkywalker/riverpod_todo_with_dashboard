import 'package:flutter/material.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: indigo200,
        body: GridView.count(
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 1,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: const [
            Card(),
            Card(),
          ],
        ),
      ),
    );
  }
}
