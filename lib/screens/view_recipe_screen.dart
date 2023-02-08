import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import '../models/recipe_model.dart';

class RecipeViewer extends StatefulWidget {
  const RecipeViewer(
      {super.key, required this.recipesCat, required this.recipeIndex});

  final int recipeIndex;
  final String recipesCat;

  @override
  State<RecipeViewer> createState() => _RecipeViewerState();
}

class _RecipeViewerState extends State<RecipeViewer> {
  late Box<RecipeModel> recipeBox;
  late int currentPortions;
  late RecipeModel recipe;

  @override
  void initState() {
    recipeBox = Hive.box(widget.recipesCat);
    recipe = recipeBox.getAt(widget.recipeIndex)!;
    currentPortions = recipe.portions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final duration = recipe.duration;
    final difficulty = recipe.difficulty;
    final instructions = recipe.instructions;
    final ingredientsQuantity = recipe.ingredientsQuantity;
    final ingredientsUnits = recipe.ingredientsUnits;
    final ingredientsNames = recipe.ingredientsNames;
    final portions = recipe.portions;
    final portionsUnits = recipe.portionsUnits;

    return MacosScaffold(
      toolBar: ToolBar(
        title: Text(recipe.title),
        titleWidth: 200,
        actions: [
          ToolBarIconButton(
            label: 'Edit',
            icon: const MacosIcon(CupertinoIcons.pencil_circle),
            showLabel: false,
            tooltipMessage: 'Edit the recipe',
            onPressed: () {
              
            },
          ),
          ToolBarIconButton(
            label: 'Delete',
            icon: const MacosIcon(CupertinoIcons.delete_left),
            showLabel: false,
            tooltipMessage: 'Delete the recipe',
            onPressed: () {
              deleteRecipe();
            },
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (BuildContext context, ScrollController scrollController) {
            return Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: MacosColors.gridColor))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 200,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              child: Image.network(
                                recipe.imagePath!,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Expanded(
                            
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const MacosIcon(CupertinoIcons.time),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      duration,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RatingIndicator(
                                  value: difficulty,
                                  iconColor: Colors.white54,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            MacosIconButton(
                                              icon: const MacosIcon(
                                                CupertinoIcons.minus,
                                                color: Colors.white54,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (currentPortions > 1) {
                                                    currentPortions--;
                                                  }
                                                });
                                              },
                                            ),
                                            Text(
                                              currentPortions.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            MacosIconButton(
                                              icon: const MacosIcon(
                                                CupertinoIcons.plus,
                                                color: Colors.white54,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  currentPortions++;
                                                });
                                              },
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(portionsUnits)
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Ingredients:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    controller: scrollController,
                                    itemCount: ingredientsNames.length,
                                    itemBuilder: ((context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Text('• '),
                                              Text(
                                                (ingredientsQuantity[index] *
                                                        currentPortions /
                                                        portions)
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(ingredientsUnits[index]),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                      ingredientsNames[index]))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      );
                                    })),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Instructions:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: MacosColors.gridColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    controller: scrollController,
                                    itemCount: instructions.length,
                                    itemBuilder: ((context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text('${index+1}. '),
                                              Text(instructions[index])],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      );
                                    })
                      )
                    ),
                  )
                ],
              ),
            ));
          },
        )
      ],
    );
  }

  deleteRecipe() async {
    await recipe.delete().whenComplete(() {
      if (!mounted) return;
      Navigator.of(context).pop(true);
    });
  }
}
