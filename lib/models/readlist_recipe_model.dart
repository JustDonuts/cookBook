import 'package:hive/hive.dart';

part 'readlist_recipe_model.g.dart';

@HiveType(typeId: 1)
class ReadRecModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String link;
  @HiveField(2)
  final String category;

  ReadRecModel({
    required this.title,
    required this.link,
    required this.category
  });

  @override
  String toString() {
    return 'ReadingList Recipe (Title: $title , link: $link)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReadRecModel && other.title == title;
  }

  @override
  int get hashCode {
    return title.hashCode;
  }
}
