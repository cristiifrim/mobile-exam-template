import 'package:flutter/material.dart';
import 'package:nutritionapp/business_logic/connection_status_manager.dart';
import 'package:nutritionapp/business_logic/meals_business_logic.dart';
import 'package:nutritionapp/data_access/app_database.dart';
import 'package:nutritionapp/screens/home_page.dart';
import 'package:nutritionapp/screens/manage_page.dart';
import 'package:nutritionapp/screens/profile_page.dart';
import 'package:nutritionapp/screens/reports_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusManager connectionStatus =
      ConnectionStatusManager.getInstance();
  connectionStatus.initialize();
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final mealBusinessLogic = MealBusinessLogic(database.mealDao);
  runApp(MainApp(mealBusinessLogic: mealBusinessLogic));
}

class MainApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final MealBusinessLogic mealBusinessLogic;

  MainApp({super.key, required this.mealBusinessLogic});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            HomePage.create(scaffoldMessengerKey, mealBusinessLogic),
        '/profile': (context) => ProfilePage.create(scaffoldMessengerKey),
        '/manage': (context) =>
            ManagePage.create(scaffoldMessengerKey, mealBusinessLogic),
        '/reports': (context) =>
            ReportsPage.create(scaffoldMessengerKey, mealBusinessLogic)
      },
    );
  }
}
