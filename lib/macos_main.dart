import 'dart:async';
import 'package:cook_book_flutter/models/readlist_recipe_model.dart';
import 'package:cook_book_flutter/models/recipe_model.dart';
import 'package:cook_book_flutter/screens/about_screen.dart';
import 'package:cook_book_flutter/screens/readlist_screen.dart';
import 'screens/recipes_by_cat_screen.dart';
import 'package:cook_book_flutter/screens/create_recipe_screen.dart';
import 'package:cook_book_flutter/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_size/window_size.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  setWindowMinSize(const Size(750, 400));
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeModelAdapter());
  Hive.registerAdapter(ReadRecModelAdapter());
  await Hive.openBox<RecipeModel>('Breakfast and Brunch');
  await Hive.openBox<RecipeModel>('Pasta');
  await Hive.openBox<RecipeModel>('Mains');
  await Hive.openBox<RecipeModel>('Desserts');
  await Hive.openBox<ReadRecModel>('ReadingListRecipes');

  // Use to delete all the recipes/boxes
  // Hive.box('ReadingListRecipes').deleteFromDisk();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      debugShowCheckedModeBanner: false,
      title: 'cookBook',
      theme: MacosThemeData(
          primaryColor: MacosThemeData.dark().primaryColor,
          brightness: MacosThemeData.dark().brightness,
          iconTheme: const MacosIconThemeData(
              color: Color.fromRGBO(247, 159, 121, 1)),),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'cookBook Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  final List<String> catNames = [
    'Breakfast and Brunch',
    'Pasta',
    'Mains',
    'Desserts'
  ];
  final List<Widget> pages = [
    HomeScreen(
      key: UniqueKey(),
    ),
    RecipeByCatScreen(
        key: UniqueKey(), recipesCategory: 'Breakfast and Brunch'),
    RecipeByCatScreen(key: UniqueKey(), recipesCategory: 'Pasta'),
    RecipeByCatScreen(key: UniqueKey(), recipesCategory: 'Mains'),
    RecipeByCatScreen(key: UniqueKey(), recipesCategory: 'Desserts'),
    ReadingListScreen(key: UniqueKey()),
    AboutScreen(
      key: UniqueKey(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
        sidebar: Sidebar(
            top: const Text('cookBook'),
            builder: (((context, scrollController) {
              return SidebarItems(
                currentIndex: currentIndex,
                onChanged: ((value) {
                  setState(() {
                    currentIndex = value;
                  });
                }),
                items: const [
                  SidebarItem(
                    // leading: MacosIcon(CupertinoIcons.home),
                    // selectedColor: Color.fromRGBO(247, 159, 121, 1),
                    label: Text('🏠  Home'),
                  ),
                  SidebarItem(
                      // leading: MacosIcon(Icons.egg_alt_rounded),
                      // selectedColor: Color.fromRGBO(247, 159, 121, 1),
                      label: Text('🍳  Breakfast and Brunch')),
                  SidebarItem(
                      // leading: MacosIcon(Icons.ramen_dining_rounded),
                      // selectedColor: Color.fromRGBO(247, 159, 121, 1),
                      label: Text('🍝  Pasta')),
                  SidebarItem(
                      // leading: MacosIcon(Icons.dinner_dining_rounded),
                      // selectedColor: Color.fromRGBO(247, 159, 121, 1),
                      label: Text('🍔  Mains')),
                  SidebarItem(
                      // leading: MacosIcon(Icons.icecream_rounded),
                      // selectedColor: Color.fromRGBO(247, 159, 121, 1),
                      label: Text('🧁  Desserts')),
                  SidebarItem(
                      // leading: MacosIcon(Icons.bookmark_rounded),
                      // selectedColor: Color.fromRGBO(247, 159, 121, 1),
                      label: Text('📚  Readlist')),
                  SidebarItem(
                      // leading: MacosIcon(CupertinoIcons.question_circle),
                      // selectedColor: Color.fromRGBO(247, 159, 121, 1),
                      label: Text('👨🏻‍💻  About')),
                ],
              );
            })),
            minWidth: 200,
            startWidth: 200,
            maxWidth: 250,
            bottom: PushButton(
              buttonSize: ButtonSize.large,
              color: Colors.transparent,
              child: Row(
                children: const [
                  MacosIcon(CupertinoIcons.add),
                  Text('  New recipe'),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateRecipe()),
                ).then((_) {
                  onGoBack();
                });
              },
            )),
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ));
  }

  Future<void> onGoBack() async {
    setState(
      () {
        pages.removeAt(0);
        pages.insert(
          0,
          HomeScreen(
            key: UniqueKey(),
          ),
        );
      },
    );
  }
}
