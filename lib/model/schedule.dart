import 'package:drift/drift.dart';

//드리프트는 Dart 언어를 위한 ORM(Object-Relational Mapping) 라이브러리다.
//ORM은 객체와 SQL DB 간의 매핑을 자동화해주는 도구로
//개발자가 SQL 쿼리를 직접 작성하지 않고도 객체 지향적인 방식으로 데이터베이스를 다룰 수 있게 해준다.
//드리프트는 SQLite와 PostgreSQL 데이터베이스를 지원합니다.
class Schedules extends Table {
  //칼럼 구현은 getter로 한다.
  //이렇게 만들면 drift가 알아서 sqlite 가지고 db를 만든다.
  //PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();
  //내용
  TextColumn get content => text()();
  //날짜
  DateTimeColumn get date => dateTime()();
  //시작 시간
  IntColumn get startTime => integer()();
  //끝 시간
  IntColumn get endTime => integer()();
  //Category Emoji Table ID
  IntColumn get colorId => integer()();
  //생성 날짜
  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now(),
      )();
}
