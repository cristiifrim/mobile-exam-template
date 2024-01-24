import 'package:floor/floor.dart';
import 'package:nutritionapp/data_access/models/meal.dart';

@dao
abstract class MealDao {
  @Query('SELECT * FROM Meals')
  Future<List<Meal>> getAllMeals();

  @insert
  Future<int> insertMeal(Meal meal);

  @insert
  Future<List<int>> insertMeals(List<Meal> meal);

  @delete
  Future<void> deleteMeal(Meal meal);

  @Query('DELETE FROM Meals')
  Future<void> clearMeals();

  @update
  Future<void> updateMeal(Meal meal);

  @update
  Future<void> updateMeals(List<Meal> meals);
}