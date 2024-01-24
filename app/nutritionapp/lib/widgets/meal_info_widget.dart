import 'package:flutter/material.dart';
import 'package:nutritionapp/data_access/models/meal.dart';

class MealInfoWidget extends StatelessWidget {
  final VoidCallback? onDelete;
  final Meal meal;
  final bool isDeleteEnabled;

  const MealInfoWidget(
      {Key? key,
      required this.meal,
      this.onDelete,
      this.isDeleteEnabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${meal.name}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Type: ${meal.type}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Calories: ${meal.calories} kcal',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Consumption Date: ${_formatDate(meal.date)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                        width: 300,
                        child: Text(
                          'Notes: ${meal.notes}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        )),
                  ],
                ),
                if (isDeleteEnabled)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      onDelete!();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
