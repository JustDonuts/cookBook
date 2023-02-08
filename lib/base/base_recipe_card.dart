import 'dart:async';
import 'dart:io';

import 'package:cook_book_flutter/screens/view_recipe_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:macos_ui/macos_ui.dart';

class RecipeCard extends StatelessWidget {
  final String duration;
  final String title;
  final double difficulty;
  final String recipesCat;
  final int recipeIndex;
  final String? imagePath;

  bool get hasImage => imagePath?.isNotEmpty == true;

  const RecipeCard(
      {Key? key,
      required this.title,
      required this.duration,
      required this.difficulty,
      required this.recipesCat,
      required this.recipeIndex,
      this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        goToRecipe(context, recipeIndex);
      }),
      child: Card(
        color: MacosTheme.of(context).dividerColor,
        child: Column(
          children: [
            Flexible(
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4.0),
                    topLeft: Radius.circular(4.0),
                  ),
                  child: imagePath == null
                      ? Image.asset(
                          'assets/images/${recipesCat.replaceAll(' ', '').toLowerCase()}.png',
                          fit: BoxFit.fitWidth,
                        )
                      : Image.network(
                          imagePath!,
                          fit: BoxFit.fitWidth,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const MacosIcon(CupertinoIcons.time),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            duration,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RatingIndicator(
                        amount: difficulty.toInt() + 1,
                        value: difficulty,
                        iconColor: Colors.white30,
                        iconSize: 22,
                        ratedIcon: (recipesCat == 'Breakfast and Brunch')
                            ? Icons.cookie_rounded
                            : (recipesCat == 'Pasta')
                                ? Icons.ramen_dining_rounded
                                : (recipesCat == 'Mains')
                                    ? Icons.lunch_dining_rounded
                                    : Icons.cake,
                        unratedIcon: (recipesCat == 'Breakfast and Brunch')
                            ? Icons.cookie_outlined
                            : (recipesCat == 'Pasta')
                                ? Icons.ramen_dining_outlined
                                : (recipesCat == 'Mains')
                                    ? Icons.lunch_dining_outlined
                                    : Icons.cake_outlined,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToRecipe(context, int idx) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeViewer(
                  recipeIndex: idx,
                  recipesCat: recipesCat,
                )));
  }
}
