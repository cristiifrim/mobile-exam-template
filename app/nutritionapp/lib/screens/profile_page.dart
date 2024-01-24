import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  const ProfilePage(this.scaffoldMessengerKey, {super.key});

  factory ProfilePage.create(GlobalKey<ScaffoldMessengerState> key) {
    return ProfilePage(key);
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing ? saveUserData() : isEditing = true;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              enabled: isEditing,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _birthdayController,
              readOnly: true,
              enabled: isEditing,
              onTap: () {
                if (isEditing) {
                  _selectDate(context);
                }
              },
              decoration: const InputDecoration(labelText: 'Birthday'),
            ),
            const SizedBox(height: 20),
            Text(
              'Age: ${_selectedDate != null ? calculateAge(_selectedDate) : ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _heightController,
              enabled: isEditing,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              enabled: isEditing,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
          ],
        ),
      ),
    );
  }

  String calculateAge(DateTime? birthDate) {
    int age = 0;
    if (birthDate != null) {
      DateTime currentDate = DateTime.now();
      age = currentDate.year - birthDate.year;
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        age--;
      }
    }
    return age.toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Save user data to shared preferences
  Future<void> saveUserData() async {
    isEditing = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setString('birthday', _birthdayController.text);
    prefs.setDouble('height', double.tryParse(_heightController.text) ?? 0.0);
    prefs.setDouble('weight', double.tryParse(_weightController.text) ?? 0.0);
  }

  // Load user data from shared preferences
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _birthdayController.text = prefs.getString('birthday') ?? '';
      _heightController.text = prefs.getDouble('height')?.toString() ?? '';
      _weightController.text = prefs.getDouble('weight')?.toString() ?? '';
      _selectedDate = DateTime.parse(_birthdayController.text);
    });
  }
}
