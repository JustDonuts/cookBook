# cookBook

A simple Flutter app for MacOS to save, view and store your favourite recipes. 

![alt text](https://user-images.githubusercontent.com/44927443/220470271-01870291-ef17-4f08-8cbb-ddc8557c33cb.png)

## What is it?
This simple app allows you to write and save your favourite recipes. This is not my first Flutter project, but it is the first time using the amazing [MacOS UI](https://pub.dev/packages/macos_ui) package. 

## What it does:
The key features of the app are:
- Locally save recipes with title, ingredients, instructions, difficulty, portions and time in a [Hive](https://pub.dev/packages/hive_flutter) box
- Search for recipes saved in the Home Screen
- Automatically retrieves a cover image for the recipe by scraping Yahoo Images. It is also possible to use the stock image for the category instead of the web-scraped one. The stock one will be used also in case of no internet conneciton
- When viewing a recipe, the portions can be adjusted as needed, resulting in the automatic adjustment of the ingredients quantities (my favopurite feature)

## What I would like to improve:
There are a few feature I would like to add in the future, some of which I am actively working on, such as:
- Option to choose a web image for the recipe, or a local image. The latter is much more complicated to do, as MacOS is very strict on accessing local files
- Modify an existing recipe (coming soon...)
- Export the recipe or the shopping list to phone. This is tricky as there is no AirDrop integration with flutter as far as I know. It could be possible to export a `.txt` file and open it in the notes to automatically sync it with the phone, but it is not very straightforward...
- 



## Why?

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Screenshots:
#### Creating a recipe
![Screenshot 2023-02-13 at 00 39 14](https://user-images.githubusercontent.com/44927443/220471645-4dcdaa21-89ca-4869-8c71-d0234cea418b.png)

#### Recipes are stored by category
![Screenshot 2023-02-13 at 00 34 08](https://user-images.githubusercontent.com/44927443/220471776-3412ddef-685d-4a36-9145-a465dc8c1eaa.png)

#### Save onlinde recipes in a reading list
![Screenshot 2023-02-13 at 00 34 16](https://user-images.githubusercontent.com/44927443/220471801-26f034dc-0a63-4ac7-a8e0-ff4431c08bf9.png)


#### Search for recipes in the home page
![Screenshot 2023-02-13 at 00 33 57](https://user-images.githubusercontent.com/44927443/220471790-82fb230f-a42b-4a5d-89d7-6b66b39d9327.png)
