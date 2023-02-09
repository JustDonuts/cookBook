import 'package:cook_book_flutter/models/readlist_recipe_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadingListScreen extends StatefulWidget {
  const ReadingListScreen({super.key});

  @override
  State<ReadingListScreen> createState() => _ReadingListScreenState();
}

class _ReadingListScreenState extends State<ReadingListScreen> {
  late Box<ReadRecModel> recipes2readBox;
  late ValueListenable listenable;

  final List<String> catNames = <String>[
    'Breakfast and Brunch',
    'Pasta',
    'Mains',
    'Desserts'
  ];

  final List<String> catSimbols = <String>['🍳 ', '🍝 ', '🍔 ', '🧁 '];

  final _formKeyRead = GlobalKey<FormState>();
  String selectedCat = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController catController = TextEditingController();

  @override
  void initState() {
    recipes2readBox = Hive.box('ReadingListRecipes');
    listenable = recipes2readBox.listenable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContentArea(builder: (context, scrollController) {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
            child: Text(
              'Reading list',
              style: TextStyle(fontSize: 30),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Save online recipes'),
          ),
          Form(
            key: _formKeyRead,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Text('Add a recipe from a link to save it for later'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            MacosSearchField(
                              controller: catController,
                              placeholder: 'Category',
                              results: catNames
                                  .map((e) => SearchResultItem(e))
                                  .toList(),
                              onResultSelected: (resultItem) {
                                selectedCat = resultItem.toString();
                                catController.text = resultItem.searchKey;
                              },
                            ),
                            MacosTextField(
                              placeholder: 'Title of the recipe',
                              controller: titleController,
                            ),
                            MacosTextField(
                              placeholder: 'Link to the recipe',
                              controller: linkController,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          addRec2List();
                        },
                        child: const SizedBox(
                            width: 50,
                            child: MacosIcon(
                              CupertinoIcons.add_circled_solid,
                              size: 25,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (recipes2readBox.isEmpty)
            const Text(
                'You have no recipes yet, add them by using the form above',
                style: TextStyle(color: Colors.white30)),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: ValueListenableBuilder(
              valueListenable: listenable,
              builder: (context, value, child) {
                return ListView.builder(
                    itemCount: recipes2readBox.length,
                    itemBuilder: ((context, index) {
                      final recipe =
                          recipes2readBox.getAt(index) as ReadRecModel;
                      return Card(
                        color: MacosTheme.of(context).dividerColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              if (recipe.category == catNames[0])
                                Text(
                                  catSimbols[0],
                                  style: const TextStyle(fontSize: 20),
                                ),
                              if (recipe.category == catNames[1])
                                Text(
                                  catSimbols[1],
                                  style: const TextStyle(fontSize: 20),
                                ),
                              if (recipe.category == catNames[2])
                                Text(
                                  catSimbols[2],
                                  style: const TextStyle(fontSize: 20),
                                ),
                              if (recipe.category == catNames[3])
                                Text(
                                  catSimbols[3],
                                  style: const TextStyle(fontSize: 20),
                                ),
                              Text(
                                recipe.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MacosIconButton(
                                      icon:
                                          const MacosIcon(CupertinoIcons.link),
                                      onPressed: (() {
                                        _launchUrl(recipe.link);
                                      }),
                                    ),
                                    MacosIconButton(
                                      icon: const MacosIcon(
                                          CupertinoIcons.delete_left),
                                      onPressed: (() {
                                        recipe.delete();
                                      }),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }));
              },
            ),
          ))
        ],
      );
    });
  }

  void addRec2List() async {
    final isValid = _formKeyRead.currentState?.validate();
    recipes2readBox = Hive.box('ReadingListRecipes');

    if (isValid != null && isValid) {
      final recipe2read = ReadRecModel(
          title: titleController.text,
          link: linkController.text,
          category: catController.text);
      await recipes2readBox.add(recipe2read);
      titleController.clear();
      linkController.clear();
      catController.clear();
    }
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
