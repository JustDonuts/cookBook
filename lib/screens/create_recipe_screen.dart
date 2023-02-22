import 'dart:io';
import 'package:cook_book_flutter/models/recipe_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({super.key});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  late Box<RecipeModel> recipeBox;

  final List<String> recipeCats = <String>[
    'Breakfast and Brunch',
    'Pasta',
    'Mains',
    'Desserts'
  ];
  var recipeCat = 'Breakfast and Brunch';
  var difficultyValue = 0.0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController recipeTitleController = TextEditingController();
  TextEditingController recipeInstructionsController = TextEditingController();
  TextEditingController recipeTimeController = TextEditingController();
  TextEditingController recipePortionsController = TextEditingController();
  TextEditingController recipePortionsUnitsController = TextEditingController();
  String? recipeImagePath;

  bool hasImage = false;

  TextEditingController localQuantitiesController = TextEditingController();
  TextEditingController localUnitsController = TextEditingController();
  TextEditingController localIngredientsController = TextEditingController();
  List<double> localQuantitiesList = <double>[];
  List<String> localUnitsList = <String>[];
  List<String> localIngredientsList = <String>[];
  List<String> localInstructionsList = <String>[];
  TextEditingController localInstructionsController = TextEditingController();
  final FocusNode instructionsFocusNode = FocusNode();
  final FocusNode ingredientsFocusNode = FocusNode();

  int get instructionIndex => localInstructionsList.length + 1;
  bool get titleEmpty => recipeTitleController.text.isEmpty;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    recipeTitleController.dispose();
    recipeInstructionsController.dispose();
    recipeTimeController.dispose();
    recipePortionsController.dispose();
    recipePortionsUnitsController.dispose();
    localQuantitiesController.dispose();
    localUnitsController.dispose();
    localIngredientsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Recipe'),
        titleWidth: 100,
        actions: [
          ToolBarIconButton(
            label: 'Save',
            icon: const MacosIcon(CupertinoIcons.floppy_disk),
            showLabel: true,
            tooltipMessage: 'Save the recipe',
            onPressed: () {
              addRecipe();
            },
          ),
          ToolBarIconButton(
            label: 'Delete',
            icon: const MacosIcon(CupertinoIcons.delete),
            showLabel: true,
            tooltipMessage: 'Discard draft',
            onPressed: () {
              if (!mounted) return;
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Category:  '),
                                MacosPopupButton<String>(
                                  value: recipeCat,
                                  items: recipeCats
                                      .map<MacosPopupMenuItem<String>>(
                                          (String value) {
                                    return MacosPopupMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      recipeCat = newValue!;
                                    });
                                  },
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 250,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                if (!hasImage)
                                  SizedBox(
                                      width: 250,
                                      height: 200,
                                      child: Image.asset(
                                        'assets/images/${recipeCat.replaceAll(' ', '').toLowerCase()}.png',
                                        fit: BoxFit.fitHeight,
                                      )),
                                if (hasImage)
                                  (recipeImagePath != null)
                                      ? SizedBox(
                                          width: 250,
                                          height: 200,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {});
                                            },
                                            child: Image.network(
                                              recipeImagePath!,
                                              fit: BoxFit.fitWidth,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 250,
                                          height: 200,
                                          child: Center(
                                              child: ProgressCircle(
                                            value: null,
                                          ))),
                                hasImage
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: PushButton(
                                          buttonSize: ButtonSize.small,
                                          onPressed: () async {
                                            setState(() {
                                              hasImage = false;
                                              recipeImagePath = null;
                                            });
                                          },
                                          child: const Text(
                                            'Use standard image',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: PushButton(
                                          buttonSize: ButtonSize.small,
                                          color: (!titleEmpty)
                                              ? MacosThemeData.dark()
                                                  .pushButtonTheme
                                                  .color
                                              : MacosThemeData.dark()
                                                  .pushButtonTheme
                                                  .disabledColor,
                                          onPressed: () async {
                                            if (titleEmpty) {
                                            } else {
                                              setState(() {
                                                hasImage = true;
                                              });
                                              recipeImagePath =
                                                  await getFirstImageUrl(
                                                      recipeTitleController
                                                          .text);
                                              setState(() {});
                                            }
                                          },
                                          child: const Text(
                                            'Use web image',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Title:',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MacosTextField(
                                          controller: recipeTitleController,
                                          placeholder: 'Name of the recipe...',
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      MacosTooltip(
                                        message: hasImage
                                            ? 'Refresh web image'
                                            : 'Refresh web image (when added)',
                                        child: MacosIconButton(
                                          onPressed: () async {
                                            if (hasImage) {
                                              setState(() {
                                                recipeImagePath = null;
                                              });
                                              recipeImagePath =
                                                  await getFirstImageUrl(
                                                      recipeTitleController
                                                          .text);
                                              setState(() {});
                                            } else {}
                                          },
                                          icon: MacosIcon(
                                            CupertinoIcons.photo,
                                            color: hasImage
                                                ? MacosThemeData.dark()
                                                    .pushButtonTheme
                                                    .color
                                                : MacosThemeData.dark()
                                                    .pushButtonTheme
                                                    .disabledColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  'Duration:',
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 100),
                                                    child: MacosTextField(
                                                      placeholder: '1:30',
                                                      controller:
                                                          recipeTimeController,
                                                    ),
                                                  ),
                                                ),
                                                const Text(' hh:mm')
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  'Difficulty:',
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 29,
                                                  child: RatingIndicator(
                                                    iconSize: 25,
                                                    ratedIcon: (recipeCat ==
                                                            'Breakfast and Brunch')
                                                        ? Icons.egg
                                                        : (recipeCat == 'Pasta')
                                                            ? Icons
                                                                .ramen_dining_rounded
                                                            : (recipeCat ==
                                                                    'Mains')
                                                                ? Icons
                                                                    .lunch_dining_rounded
                                                                : Icons.cake,
                                                    unratedIcon: (recipeCat ==
                                                            'Breakfast and Brunch')
                                                        ? Icons.egg_outlined
                                                        : (recipeCat == 'Pasta')
                                                            ? Icons
                                                                .ramen_dining_outlined
                                                            : (recipeCat ==
                                                                    'Mains')
                                                                ? Icons
                                                                    .lunch_dining_outlined
                                                                : Icons
                                                                    .cake_outlined,
                                                    amount: 5,
                                                    value: difficultyValue,
                                                    onChanged: (v) {
                                                      setState(() =>
                                                          difficultyValue = v);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  'Portions:',
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                  child: MacosTextField(
                                                    placeholder: '4',
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    controller:
                                                        recipePortionsController,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: MacosTextField(
                                                    placeholder:
                                                        '(Units) People, bowls...',
                                                    controller:
                                                        recipePortionsUnitsController,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: MacosColors.gridColor))),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Ingredients:',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Quantity:',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              width: 50,
                              child: MacosTextField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                placeholder: '0',
                                controller: localQuantitiesController,
                                focusNode: ingredientsFocusNode,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const Text(' Units:'),
                            SizedBox(
                              width: 80,
                              child: MacosTextField(
                                placeholder: 'gr',
                                controller: localUnitsController,
                              ),
                            ),
                            Flexible(
                              child: MacosTextField(
                                controller: localIngredientsController,
                                placeholder:
                                    'Oil, salt... (press enter to add)',
                                onSubmitted: (value) {
                                  addLocIngredient();
                                },
                              ),
                            ),
                            MacosIconButton(
                              icon: const MacosIcon(CupertinoIcons.add),
                              onPressed: () {
                                addLocIngredient();
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: localIngredientsList.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  const Text('• '),
                                  Text(localQuantitiesList[index].toString()),
                                  const Text(' '),
                                  Text(localUnitsList[index]),
                                  const Text(' '),
                                  Text(localIngredientsList[index]),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  MacosIconButton(
                                    onPressed: () {
                                      localQuantitiesList.removeAt(index);
                                      localUnitsList.removeAt(index);
                                      localIngredientsList.removeAt(index);
                                      setState(() {});
                                    },
                                    icon: const MacosIcon(
                                        CupertinoIcons.delete_left),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: MacosColors.gridColor))),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Instructions:',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: localInstructionsList.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Flexible(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                  child: Text(
                                    '${index + 1}. ${localInstructionsList[index]}',
                                    softWrap: true,
                                  ),
                                )),
                                const SizedBox(
                                  width: 8,
                                ),
                                MacosIconButton(
                                  onPressed: () {
                                    localInstructionsList.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: const MacosIcon(
                                      CupertinoIcons.delete_left),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Row(
                          children: [
                            Flexible(
                              child: MacosTextField(
                                autocorrect: true,
                                focusNode: instructionsFocusNode,
                                controller: localInstructionsController,
                                placeholder: '$instructionIndex. Do this...',
                                onSubmitted: (value) {
                                  addLocInstruction();
                                },
                              ),
                            ),
                            MacosIconButton(
                              icon: const MacosIcon(CupertinoIcons.add),
                              onPressed: () {
                                addLocInstruction();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  void addLocIngredient() async {
    if (localIngredientsController.text.length > 2) {
      setState(() {
        localQuantitiesList.add(double.parse(localQuantitiesController.text));
        localUnitsList.add(localUnitsController.text);
        localIngredientsList.add(localIngredientsController.text);

        sleep(const Duration(milliseconds: 1));

        localQuantitiesController.clear();
        localUnitsController.clear();
        localIngredientsController.clear();
        ingredientsFocusNode.requestFocus();
      });
    }
  }

  void addLocInstruction() async {
    if (localInstructionsController.text.isNotEmpty) {
      setState(() {
        localInstructionsList.add(localInstructionsController.text);

        sleep(const Duration(milliseconds: 1));
        localInstructionsController.clear();
        instructionsFocusNode.requestFocus();
      });
    }
  }

  void addRecipe() async {
    final isValid = _formKey.currentState?.validate();
    recipeBox = Hive.box(recipeCat);
    if (isValid != null && isValid) {
      final recipe = RecipeModel(
          title: recipeTitleController.text,
          duration: recipeTimeController.text,
          difficulty: difficultyValue,
          portions: int.parse(recipePortionsController.text),
          portionsUnits: recipePortionsUnitsController.text,
          instructions: localInstructionsList,
          ingredientsQuantity: localQuantitiesList,
          ingredientsUnits: localUnitsList,
          ingredientsNames: localIngredientsList,
          imagePath: recipeImagePath,
          category: recipeCat);
      await recipeBox.add(recipe);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  Future<String?> getFirstImageUrl(String query) async {
    final response = await http.get(Uri.parse(
        'https://images.search.yahoo.com/search/images?p=$query&imgsz=wallpaper&imgty=photo'));
    if (response.statusCode == 200) {
      final document = parse(response.body).querySelector('#results');
      final images = document!.querySelectorAll('img');
      if (images.isNotEmpty) {
        final imgLink = images[0].attributes['data-src'].toString();
        return imgLink;
      }
    }
    return '';
  }
}
