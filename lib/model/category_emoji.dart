import 'package:drift/drift.dart';

class CategoryEmojis extends Table {
  //PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  //db에 이모지가 들어갈까?
  //char로 구현이 되어 있어 가능할 것 같은데 되지 않아도 dec, hex 다 가능하니까
  //우선은 hex로 구현
  TextColumn get hexCode => text()();
}
