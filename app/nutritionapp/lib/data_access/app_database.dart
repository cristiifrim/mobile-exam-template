// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:nutritionapp/common/helpers/date_time_converter.dart';
import 'package:nutritionapp/data_access/dao/meal_dao.dart';
import 'package:nutritionapp/data_access/models/meal.dart';

part 'app_database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Meal])
abstract class AppDatabase extends FloorDatabase {
  MealDao get mealDao;
}
