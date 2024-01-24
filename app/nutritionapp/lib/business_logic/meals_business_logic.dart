import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:nutritionapp/common/constants.dart';
import 'package:nutritionapp/common/exceptions/application_exception.dart';
import 'package:nutritionapp/data_access/dao/meal_dao.dart';
import 'package:nutritionapp/data_access/models/meal.dart';

class MealBusinessLogic {
  final MealDao _mealDao;

  List<Meal> meals = [];
  List<String> types = [];
  bool hasNetwork = false;

  MealBusinessLogic(this._mealDao);

  Future<List<Meal>> getAllMeals() async {
    if (hasNetwork) {
      try {
        print("Retrieve from server");
        Response serverResponse = await Dio().get("${AppConstants.apiUrl}/all");
        var rawList = serverResponse.data as List;
        meals = rawList.map((e) => Meal.fromJson(e)).toList();
      } on DioException catch (e) {
        if (e.response != null) {
          throw ApplicationException(
              e.response?.data ?? "Error while requesting the meals!");
        } else {
          throw ApplicationException(
              "An unexpected error appeared while requesting the meals.");
        }
      }
    } else {
      print("Retrieve from local database");
      meals = await _mealDao.getAllMeals();
    }
    return meals;
  }

  Future<List<Meal>> getTopTenMeals() async {
    List<Meal> sortedMeals = List.from(meals);
    sortedMeals.sort((a, b) => b.calories.compareTo(a.calories));
    return sortedMeals.take(10).toList();
  }

  Future<List<String>> getAllTypes() async {
    if (hasNetwork) {
      try {
        print("Retrieve from server");
        Response serverResponse =
            await Dio().get("${AppConstants.apiUrl}/types");
        var rawList = serverResponse.data as List;
        types = rawList.map((e) => e.toString()).toList();
      } on DioException catch (e) {
        if (e.response != null) {
          throw ApplicationException(
              e.response?.data ?? "Error while requesting the types!");
        } else {
          throw ApplicationException(
              "An unexpected error appeared while requesting the types.");
        }
      }
    }
    return types;
  }

  Future<List<Meal>> getMealsByType(String type) async {
    List<Meal> mealsByType = [];
    if (hasNetwork) {
      try {
        print("Retrieve from server");
        Response serverResponse =
            await Dio().get("${AppConstants.apiUrl}/meals/$type");
        var rawList = serverResponse.data as List;
        mealsByType = rawList.map((e) => Meal.fromJson(e)).toList();
      } on DioException catch (e) {
        if (e.response != null) {
          throw ApplicationException(
              e.response?.data ?? "Error while requesting the meals!");
        } else {
          throw ApplicationException(
              "An unexpected error appeared while requesting the meals.");
        }
      }
    }
    return mealsByType;
  }

  Map<String, double> getCaloriesByType() {
    Map<String, double> caloriesByType = {};
    if (hasNetwork) {
      print("Retrieve calories by type");
      for (var meal in meals) {
        if (caloriesByType.containsKey(meal.type)) {
          caloriesByType[meal.type] =
              caloriesByType[meal.type]! + meal.calories;
        } else {
          caloriesByType[meal.type] = meal.calories;
        }
      }
    }
    return caloriesByType;
  }

  Future<void> addMeal(String name, String type, double calories, DateTime date,
      String notes) async {
    var meal = Meal(
        name: name, type: type, calories: calories, date: date, notes: notes);

    if (hasNetwork) {
      try {
        print("Add on server");
        Response serverResponse = await Dio()
            .post("${AppConstants.apiUrl}/meal", data: meal.toJson());
        meal = Meal.fromJson(serverResponse.data);
      } on DioException catch (e) {
        if (e.response != null) {
          print(e.response);
          throw ApplicationException(
              e.response?.data["text"] ?? "Error while adding the meal!");
        } else {
          throw ApplicationException(
              "An unexpected error appeared while adding the meal.");
        }
      }
    } else {
      print("Add on local db");
      meal.localId = await _mealDao.insertMeal(meal);
    }

    if (meal.id == null || !meals.map((e) => e.id).contains(meal.id)) {
      meals.add(meal);
    }
  }

  Meal addRemoteMeal(String remoteMeal) {
    Map<String, dynamic> map;
    try {
      map = Map<String, dynamic>.from(jsonDecode(remoteMeal));
      print(map);
    } catch (e) {
      throw ApplicationException('Error decoding JSON: $remoteMeal');
    }

    var meal = Meal.fromJson(map);
    if (!meals.map((e) => e.id).contains(meal.id)) {
      meals.add(meal);
    }

    return meal;
  }

  Future<void> deleteMeal(int index) async {
    var meal = meals.removeAt(index);
    if (hasNetwork) {
      try {
        print("Delete on server");
        int mealId = meal.id ?? -1;
        await Dio().delete("${AppConstants.apiUrl}/meal/$mealId");
      } on DioException catch (e) {
        if (e.response != null) {
          throw Exception(e.response?.data ?? "Error while deleting the meal!");
        } else {
          throw Exception(
              "An unexpected error appeared while deleting the meal.");
        }
      }
    }
  }

  Future<void> syncLocalDbWithServer() async {
    print("Sync local with server");
    if (hasNetwork) {
      var localMeals = await _mealDao.getAllMeals();
      try {
        Response serverResponse = await Dio().get("${AppConstants.apiUrl}/all");
        var rawList = serverResponse.data as List;
        meals = rawList.map((e) => Meal.fromJson(e)).toList();
      } on DioException catch (e) {
        if (e.response != null) {
          throw ApplicationException(
              e.response?.data ?? "Error while requesting the meals!");
        } else {
          throw ApplicationException(
              "An unexpected error appeared while requesting the meals.");
        }
      }

      var locallyAddedMeals = localMeals.where((x) => x.id == null).toList();
      await _serverBulkAddMeals(locallyAddedMeals);
      _mealDao.clearMeals();
    }
  }

  Future<void> saveMeals() async {
    await _mealDao.insertMeals(meals);
  }

  Future<void> updateMeals() async {
    await _mealDao.updateMeals(meals);
  }

  Future<void> _serverBulkAddMeals(List<Meal> meals) async {
    if (hasNetwork && meals.isNotEmpty) {
      try {
        print("Bulk Add on server");
        meals.forEach((element) async {
          await Dio()
              .post("${AppConstants.apiUrl}/meal", data: element.toJson());
        });
      } on DioException catch (e) {
        if (e.response != null) {
          throw ApplicationException(
              e.response?.data["text"] ?? "Error while bulk adding the Meals!");
        } else {
          throw ApplicationException(
              "An unexpected error appeared while bulk adding the Meals.");
        }
      }
    }
  }
}
