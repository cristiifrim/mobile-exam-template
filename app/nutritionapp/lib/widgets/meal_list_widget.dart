import 'package:flutter/material.dart';
import 'package:nutritionapp/data_access/models/meal.dart';
import 'package:nutritionapp/widgets/meal_info_widget.dart';

class MealListWidget extends StatelessWidget {
  final List<Meal> meals;

  const MealListWidget({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) {
        return MealInfoWidget(meal: meals[index]);
      },
    );
  }
}