import 'package:flutter/material.dart';
import 'package:riverpod_todo_with_dashboard/screens/non_login_screens/home_banner.dart';

import 'home_middle_screen.dart';
import './buttons_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: const [
              Expanded(
                child: Center(child: HomeBanner()),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "🌱",
                  style: TextStyle(
                    fontFamily: 'NotoColorEmoji',
                    fontSize: 30.0,
                  ),
                ),
              ),
              Expanded(
                child: Center(child: HomeMiddleScreen()),
              ),
              Expanded(
                child: Center(child: ButtonsScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}