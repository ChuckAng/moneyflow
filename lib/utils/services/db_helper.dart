import 'package:hive/hive.dart';

class DbHelper {
  late Box box;

  DbHelper() {
    openBox();
  }

  openBox() {
    box = Hive.box('money');
  }

  Future addData(double amount, DateTime date, String type, String category, String note) async {
    var value = {'amount': amount, 'date': date, 'type': type, 'category': category, 'note': note};
    box.add(value);
    
  }

  Future<Map> fetchData() {
    if (box.values.isEmpty) {
      return Future.value({});
    } else {
      return Future.value(box.toMap());
    }
  }
}
