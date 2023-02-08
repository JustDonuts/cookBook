import 'package:hive/hive.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 0)
class RecipeModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String duration;
  @HiveField(2)
  final double difficulty;
  @HiveField(3)
  final int portions;
  @HiveField(4)
final String portionsUnits;
@HiveField(5)
final List<String> instructions;
@HiveField(6)
final List<double> ingredientsQuantity;
@HiveField(7)
final List<String> ingredientsUnits;
@HiveField(8)
final List<String> ingredientsNames;
@HiveField(9)
final String? imagePath;
@HiveField(10)
final String category;


  RecipeModel({
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.portions,
    required this.portionsUnits,
    required this.instructions,
    required this.ingredientsQuantity,
    required this.ingredientsUnits,
    required this.ingredientsNames,
    this.imagePath,
    required this.category,
    
  });

  @override
  String toString() {
    return 'RecipeModel(Title: $title)';
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecipeModel && other.title == title;
  }

  @override
  int get hashCode {
    return title.hashCode;
  }
}
