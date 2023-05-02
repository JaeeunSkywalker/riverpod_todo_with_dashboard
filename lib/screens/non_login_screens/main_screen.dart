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
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: const Center(child: HomeBanner()),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "🌱",
                    style: TextStyle(
                      fontFamily: 'NotoColorEmoji',
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: const Center(child: HomeMiddleScreen()),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: const Center(child: ButtonsScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
