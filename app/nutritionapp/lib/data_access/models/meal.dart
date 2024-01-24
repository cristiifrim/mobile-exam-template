import 'package:floor/floor.dart';

@Entity(tableName: 'Meals')
class Meal {
  @PrimaryKey(autoGenerate: true)
  int? localId;
  int? id;
  final String name;
  final String type;
  final double calories;
  final DateTime date;
  final String notes;

  Meal(
      {this.id,
      this.localId,
      required this.name,
      required this.type,
      required this.calories,
      required this.date,
      required this.notes});

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json["id"],
        name: json["name"] ?? "",
        type: json["type"] ?? "",
        calories: json["calories"] + 0.0,
        date: DateTime.parse(json["date"].toString()),
        notes: json["notes"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "calories": calories,
        "date": date.toIso8601String(),
        "notes": notes
      };
}
