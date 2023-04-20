import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:riverpod_todo_with_dashboard/screens/home_screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
      ),
      home: const MainScreen(),
    );
  }
}
