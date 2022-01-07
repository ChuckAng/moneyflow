import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getxfire/getxfire.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneyflow/view/add_expenses.dart';
import 'package:moneyflow/view/add_income.dart';
import 'package:moneyflow/view/home.dart';

import 'package:path_provider/path_provider.dart' as pathProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  await Hive.openBox('money');

  runApp(
    GetMaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/home', page: () => Home()),
        GetPage(name: '/add-income', page: () => AddIncomePage()),
        GetPage(name: '/add-expenses', page: () => const AddExpensesPage())
      ],
    ),
  );
}
