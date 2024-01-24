import 'package:flutter/material.dart';

class TypeCalorieIntakeWidget extends StatelessWidget {
  final double calories;
  final String type;

  const TypeCalorieIntakeWidget(
      {super.key, required this.type, required this.calories});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    type,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '$calories kcal',
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  )
                ])));
  }
}
