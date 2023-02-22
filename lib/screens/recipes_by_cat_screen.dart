import 'package:cook_book_flutter/base/base_recipe_card.dart';
import 'package:cook_book_flutter/models/recipe_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';

class RecipeByCatScreen extends StatefulWidget {
  const RecipeByCatScreen({super.key, required this.recipesCategory});

  final String recipesCategory;

  @override
  State<RecipeByCatScreen> createState() => _RecipeByCatScreenState();
}

class _RecipeByCatScreenState extends State<RecipeByCatScreen> {
  late Box<RecipeModel> recipeBox;
  late ValueListenable listenable;

  @override
  void initState() {
    recipeBox = Hive.box(widget.recipesCategory);
    listenable = recipeBox.listenable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      children: [
        ContentArea(builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text(
                  widget.recipesCategory,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              if (recipeBox.isEmpty)
                const Text(
                    'You have no recipes here yet, add them by using the button in the bottom left corner',
                    style: TextStyle(color: Colors.white30)),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ValueListenableBuilder(
                        valueListenable: listenable,
                        builder: (context, value, child) {
                          return GridView.builder(
                            controller: scrollController,
                            itemCount: recipeBox.length,
                            itemBuilder: ((context, index) {
                              final recipe =
                                  recipeBox.getAt(index) as RecipeModel;
                              return RecipeCard(
                                title: recipe.title,
                                duration: recipe.duration,
                                difficulty: recipe.difficulty,
                                imagePath: recipe.imagePath,
                                recipesCat: widget.recipesCategory,
                                recipeIndex: index,
                              );
                            }),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 500,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                          );
                        })),
              ),
            ],
          );
        })
      ],
    );
  }
}
