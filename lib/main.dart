import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:riverpod_todo_with_dashboard/screens/home_screens/main_screen.dart';
import 'package:riverpod_todo_with_dashboard/database/drift_database.dart';

//db에 넣을 emojis
//'🔥', 이건 아이폰 이모지라 이렇게는 안드로이드에서 사용할 수 없다, hex code로 접근해야 함!
//1f525, \u{1F525}
// ignore: constant_identifier_names
const DEFAULT_EMOJIS = [
  '🐣',
  '🐥',
  '🐔',
  '💯',
  '🎉',
  '❤️‍🔥',
  '🚿',
  '🍽',
  '📖',
  '🛏',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  //db 시작!
  //db import했으면 쿼리 바로 쓸 수 있다.
  final database = LocalDatabase();

  //GetIt으로 싱글턴 등록 끝!
  GetIt.I.registerSingleton<LocalDatabase>(database);

  final emojis = await database.getCategoryEmojis();

  if (emojis.isEmpty) {
    for (String emoji in DEFAULT_EMOJIS) {
      await database.createCategoryEmojis(
        CategoryEmojisCompanion(
          hexCode: Value(emoji),
        ),
      );
    }
  }

  //print(DEFAULT_EMOJIS);

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
