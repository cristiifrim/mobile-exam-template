import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/data_access/models/meal.dart';
import 'package:nutritionapp/widgets/meal_info_widget.dart';

class MealHistoryWidget extends StatefulWidget {
  final List<Meal> meals;
  const MealHistoryWidget({super.key, required this.meals});

  @override
  _MealHistoryWidgetState createState() => _MealHistoryWidgetState();
}

class _MealHistoryWidgetState extends State<MealHistoryWidget> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.meals.map((e) => e.date).toList().min;
    _endDate = widget.meals.map((e) => e.date).toList().max;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedStartDate != null && pickedStartDate != _startDate) {
      setState(() {
        _startDate = pickedStartDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedEndDate != null && pickedEndDate != _endDate) {
      setState(() {
        _endDate = pickedEndDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Meal> mealsInRange = widget.meals.where((meal) {
      return meal.date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          meal.date.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();

    return Column(
      children: [
        Text(
            "Meals between ${_formatDate(_startDate)} and ${_formatDate(_endDate)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        SizedBox(
          height: 225,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            itemCount: mealsInRange.length,
            itemBuilder: (context, index) {
              return MealInfoWidget(meal: mealsInRange[index]);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _selectStartDate(context),
              child: const Text('Select Start Date'),
            ),
            ElevatedButton(
              onPressed: () => _selectEndDate(context),
              child: const Text('Select End Date'),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
