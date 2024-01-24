import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class AddMealPage extends StatefulWidget {
  final Function(String, String, double, DateTime, String) onSave;
  const AddMealPage({super.key, required this.onSave});

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Meal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Meal Name'),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Meal Type'),
              ),
              TextField(
                controller: caloriesController,
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                  controller: dateController,
                  decoration:
                      const InputDecoration(labelText: 'Consumption date'),
                  keyboardType: TextInputType.number,
                  enabled: false),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                          dateController.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    ProgressDialog pr = ProgressDialog(context);
                    pr.style(message: 'Loading...');

                    await pr.show();

                    await widget.onSave(
                      nameController.text,
                      typeController.text,
                      double.parse(caloriesController.text),
                      selectedDate ?? DateTime.now(),
                      notesController.text,
                    );

                    await pr
                        .hide()
                        .then((_) => Navigator.pop(context));
                  }
                },
                child: const Text('Add Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (nameController.text.isEmpty ||
        typeController.text.isEmpty ||
        caloriesController.text.isEmpty ||
        dateController.text.isEmpty ||
        notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return false;
    }
    return true;
  }
}
