import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutritionapp/business_logic/connection_status_manager.dart';
import 'package:nutritionapp/business_logic/meals_business_logic.dart';
import 'package:nutritionapp/business_logic/web_socket_manager.dart';
import 'package:nutritionapp/screens/add_meal_page.dart';
import 'package:nutritionapp/widgets/meal_list_widget.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final MealBusinessLogic mealBusinessLogic;

  const HomePage(this.scaffoldMessengerKey, this.mealBusinessLogic,
      {super.key});

  factory HomePage.create(GlobalKey<ScaffoldMessengerState> key,
      MealBusinessLogic mealBusinessLogic) {
    return HomePage(key, mealBusinessLogic);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectionStatusManager connectionStatus =
      ConnectionStatusManager.getInstance();
  StreamSubscription? _connectionChangeStream;
  WebSocketManager? _webSocketManager;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _connectionChangeStream =
        connectionStatus.connectionChange.listen(_connectionChanged);
    connectionStatus.hasNetwork();
  }

  @override
  void dispose() {
    _webSocketManager?.disconnect();
    ConnectionStatusManager.getInstance().dispose();
    widget.mealBusinessLogic.updateMeals();
    super.dispose();
  }

  void openSnackbar(String message, int durationInSeconds) {
    widget.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: durationInSeconds),
      ),
    );
  }

  void _connectionChanged(dynamic hasNetwork) {
    if (!widget.mealBusinessLogic.hasNetwork && hasNetwork) {
      openSnackbar(
          "You are connected to internet. Your application has been updated with the server.",
          2);
      _webSocketManager = WebSocketManager(onMessageReceived: (remoteMeal) {
        var meal = widget.mealBusinessLogic.addRemoteMeal(remoteMeal);
        var message =
            "A new meal was added. Name: ${meal.name}, type: ${meal.type}, calories: ${meal.calories}";
        openSnackbar('Notification: $message', 2);
      });
      widget.mealBusinessLogic.hasNetwork = true;
    } else if (!hasNetwork) {
      openSnackbar(
          "There is no connection to internet! Loaded from local database.", 2);
      _webSocketManager?.disconnect();
      _webSocketManager = null;
      widget.mealBusinessLogic.hasNetwork = false;
      widget.mealBusinessLogic.saveMeals();
    }
    fetchData();
  }

  void addMeal(String name, String type, double calories, DateTime date,
      String notes) async {
    await widget.mealBusinessLogic
        .addMeal(name, type, calories, date, notes)
        .then((_) {
      setState(() {});
    }).catchError((e) {
      print('Error adding meal: $e');
      openSnackbar("Error adding meal: $e", 2);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: _loading || widget.mealBusinessLogic.meals.isEmpty
          ? Center(
              child: Column(children: [
              const CircularProgressIndicator(),
              const Text("Waiting for internet connection"),
              ElevatedButton(
                  onPressed: () => connectionStatus.hasNetwork(),
                  child: const Text("Retry connection"))
            ]))
          : MealListWidget(meals: widget.mealBusinessLogic.meals),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddMealPage(onSave: addMeal)),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drag_handle),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_exploration),
            label: 'Reports',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 1:
              if (!widget.mealBusinessLogic.hasNetwork) {
                openSnackbar(
                    "You cannot access this section while offline.", 1);
              } else {
                Future pushNamed = Navigator.pushNamed(context, '/manage');
                pushNamed.then((_) => setState(() {}));
              }
              break;
            case 2:
              if (!widget.mealBusinessLogic.hasNetwork) {
                openSnackbar(
                    "You cannot access this section while offline.", 1);
              } else {
                Navigator.pushNamed(context, '/reports');
              }
              break;
          }
        },
      ),
    );
  }

  fetchData() async {
    await widget.mealBusinessLogic.syncLocalDbWithServer();
    await widget.mealBusinessLogic.getAllMeals();
    setState(() {
      _loading = false;
    });
  }
}
