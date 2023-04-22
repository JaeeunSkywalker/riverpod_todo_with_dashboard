//private 값은 불러올 수 없다.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_todo_with_dashboard/model/category_emoji.dart';
import 'package:riverpod_todo_with_dashboard/model/schedule.dart';
import 'package:riverpod_todo_with_dashboard/model/schedule_with_emoji.dart';

//private 값도 다 불러올 수 있다.
//generate하는 terminal 명령어
//flutter pub run build_runner build
part 'drift_database.g.dart';

//여기 통해서 내가 만든 db를 임포트한다.
@DriftDatabase(
  tables: [
    Schedules,
    CategoryEmojis,
  ],
)

//나중에 _$~클래스는 'drift_database.g.dart' 안에서 볼 수 있다.
//처음 클래스 이름은 내가 사용할 db 이름임.
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<List<Schedule>> getSchedules() => select(schedules).get();

  Future<Schedule> getScheduleById(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryEmojis(CategoryEmojisCompanion data) =>
      into(categoryEmojis).insert(data);

  //select는 2가지 방법으로 가능, string으로 순차적으로 받을 수도 있고 future로 한꺼번에 받을 수도 있다.
  Future<List<CategoryEmoji>> getCategoryEmojis() =>
      select(categoryEmojis).get();

  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  //where 적용 방법 2가지
  //1번 ver.(정석)
  // Stream<List<Schedule>> watchSchedules(DateTime date) {
  //   final query = select(schedules);
  //   query.where((tbl) => tbl.date.equals(date));
  //   return query.watch();
  //   //select(schedules).where((tbl) => tbl.date.equals(date)).watch();
  // }

  //2번 ver.
  Stream<List<ScheduleWithEmoji>> watchSchedules(DateTime date) {
    //클래스끼리 조인하면 결과값을 담는 클래스를 따로 만들어 줘야 한다.
    //inner join은 select에 바로 붙이면 된다.
    //join할 때는 expression을 써야 된다.
    final query = select(schedules).join(
      [
        innerJoin(
          categoryEmojis,
          categoryEmojis.id.equalsExp(schedules.emojiId),
        ),
      ],
    );
    query.where(schedules.date.equals(date));
    query.orderBy([
      OrderingTerm.asc(schedules.startTime),
    ]);
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWithEmoji(
                  schedule: row.readTable(schedules),
                  categoryEmoji: row.readTable(categoryEmojis),
                ),
              )
              .toList(),
        );

    //return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  //생성한 테이블의 상태(버전)
  //테이블 구조 바뀔 때마다 버전 올려 줘야 한다.
  @override
  int get schemaVersion => 1;
}

//실제 db 파일을 보조기억장치 어디에 생성할 건지 여기서 설정
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    //TODO 3번: 웹에서 어떻게 운용할지 생각할 것
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(
      dbFolder.path,
      'db.sqlite',
    ));
    return NativeDatabase(file);
  });
}
