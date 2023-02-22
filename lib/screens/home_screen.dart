import 'package:cook_book_flutter/screens/view_recipe_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/readlist_recipe_model.dart';
import '../models/recipe_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<RecipeModel> recipeBox;
  late List<RecipeModel> filteredRecipes;
  late TextEditingController searchbarController;
  late Box<ReadRecModel> recipes2readBox;
  late ValueListenable listenable;
  late List<ReadRecModel> filteredReadRecs;
  late List<RecipeModel> allRecipesInit = [];
  bool get hasRecipes => allRecipesInit.isEmpty && recipes2readBox.isEmpty;

  final List<String> catNames = [
    'Breakfast and Brunch',
    'Pasta',
    'Mains',
    'Desserts'
  ];

  final List<String> catSimbols = <String>['🍳 ', '🍝 ', '🍔 ', '🧁 '];
  @override
  void initState() {
    recipes2readBox = Hive.box('ReadingListRecipes');
    listenable = recipes2readBox.listenable();

    searchbarController = TextEditingController();
    List<RecipeModel> allRecipes = [];
    for (String cat in catNames) {
      recipeBox = Hive.box(cat);
      allRecipes.addAll(recipeBox.values);
      allRecipesInit.addAll(recipeBox.values);
    }
    filteredRecipes = allRecipes
        .where((element) => element.title.toLowerCase().contains(''))
        .toList();

    filteredReadRecs = recipes2readBox.values
        .where((element) => element.title.toLowerCase().contains(''))
        .toList();
    super.initState();
  }

  void search(String query) {
    List<RecipeModel> allRecipes = [];
    setState(() {
      for (String cat in catNames) {
        recipeBox = Hive.box(cat);
        allRecipes.addAll(recipeBox.values);
      }
      filteredRecipes = allRecipes
          .where((element) =>
              element.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredReadRecs = recipes2readBox.values
          .where((element) =>
              element.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentArea(builder: (context, scrollController) {
      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.all(50.0),
          child: Text(
            'Welcome to your cookBook!',
            style: TextStyle(fontSize: 30),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              if (hasRecipes)
                const Padding(
                  padding: EdgeInsets.fromLTRB(60, 0, 60, 60),
                  child: Text(
                    'Welcome to cookBook, an open source Flutter app to save your favourite recipes! \n\n Once you add some recipes, you will be able to search for them below. ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    const MacosIcon(
                      CupertinoIcons.search,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: MacosTextField(
                        onChanged: search,
                        placeholder: 'Search for one of your recipes',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Column(
                          children: [
                            const Text(
                              'Your recipes:',
                              style: TextStyle(color: Colors.white30),
                            ),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 0, 20),
                                    child: GridView.builder(
                                      controller: scrollController,
                                      itemCount: filteredRecipes.length,
                                      itemBuilder: ((context, index) {
                                        final recipe = filteredRecipes[index];
                                        int recipeIndex = 0;
                                        for (String cat in catNames) {
                                          recipeBox = Hive.box(cat);
                                          if (recipeBox.values
                                              .contains(recipe)) {
                                            recipeIndex = recipeBox.values
                                                .toList()
                                                .indexOf(recipe);
                                            break;
                                          }
                                        }
                                        return GestureDetector(
                                          onTap: (() {
                                            goToRecipe(context, recipeIndex,
                                                recipe.category);
                                          }),
                                          child: Card(
                                            color: MacosTheme.of(context)
                                                .dividerColor,
                                            child: Column(
                                              children: [
                                                Flexible(
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                      child: recipe.imagePath ==
                                                              null
                                                          ? Image.asset(
                                                              'assets/images/${recipe.category.replaceAll(' ', '').toLowerCase()}.png',
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            )
                                                          : Image.network(
                                                              recipe.imagePath!,
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        recipe.title,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              const MacosIcon(
                                                                  CupertinoIcons
                                                                      .time),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                recipe.duration,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          RatingIndicator(
                                                            value: recipe
                                                                .difficulty,
                                                            iconColor:
                                                                Colors.white30,
                                                            iconSize: 20,
                                                            amount: recipe
                                                                    .difficulty
                                                                    .toInt() +
                                                                1,
                                                            ratedIcon: (recipe
                                                                        .category ==
                                                                    'Breakfast and Brunch')
                                                                ? Icons.egg
                                                                : (recipe.category ==
                                                                        'Pasta')
                                                                    ? Icons
                                                                        .ramen_dining_rounded
                                                                    : (recipe.category ==
                                                                            'Mains')
                                                                        ? Icons
                                                                            .lunch_dining_rounded
                                                                        : Icons
                                                                            .cake,
                                                            unratedIcon: (recipe
                                                                        .category ==
                                                                    'Breakfast and Brunch')
                                                                ? Icons
                                                                    .egg_outlined
                                                                : (recipe.category ==
                                                                        'Pasta')
                                                                    ? Icons
                                                                        .ramen_dining_outlined
                                                                    : (recipe.category ==
                                                                            'Mains')
                                                                        ? Icons
                                                                            .lunch_dining_outlined
                                                                        : Icons
                                                                            .cake_outlined,
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
                                      }),
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 400,
                                              childAspectRatio: 3 / 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 350),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Column(
                            children: [
                              const Text(
                                'Saved recipes:',
                                style: TextStyle(color: Colors.white30),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ValueListenableBuilder(
                                  valueListenable: listenable,
                                  builder: (context, value, child) {
                                    return ListView.builder(
                                        itemCount: filteredReadRecs.length,
                                        itemBuilder: ((context, index) {
                                          final recipe =
                                              filteredReadRecs[index];
                                          if (filteredReadRecs.isNotEmpty) {
                                            return Card(
                                              color: MacosTheme.of(context)
                                                  .dividerColor,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    if (recipe.category ==
                                                        catNames[0])
                                                      Text(
                                                        catSimbols[0],
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    if (recipe.category ==
                                                        catNames[1])
                                                      Text(
                                                        catSimbols[1],
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    if (recipe.category ==
                                                        catNames[2])
                                                      Text(
                                                        catSimbols[2],
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    if (recipe.category ==
                                                        catNames[3])
                                                      Text(
                                                        catSimbols[3],
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    Text(
                                                      recipe.title,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          MacosIconButton(
                                                            icon: const MacosIcon(
                                                                CupertinoIcons
                                                                    .link),
                                                            onPressed: (() {
                                                              _launchUrl(
                                                                  recipe.link);
                                                            }),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                                'No recipes found...');
                                          }
                                        }));
                                  },
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ]);
    });
  }

  Future<void> searchOnBack() async {
    search('');
  }

  void goToRecipe(context, int idx, String recipesCat) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeViewer(
                  recipeIndex: idx,
                  recipesCat: recipesCat,
                ))).then((_) {
      searchOnBack();
    });
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
