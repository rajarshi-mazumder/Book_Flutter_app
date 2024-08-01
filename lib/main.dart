import 'dart:ui';

import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/theme/theme_constants.dart';
import 'package:book_frontend/views/screens/authentication/silent_signin_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/books/book.dart';
import 'models/books/category.dart';
import 'models/books/author.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(AuthorAdapter());

  await Hive.openBox("books_data");
  await Hive.openBox("user_data");

  Hive.openBox<Book>('all_books');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppDataProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => BooksProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: customTheme,
        debugShowCheckedModeBanner: false,
        // home: const HomePage(),
        home: const SilentSignInPage(),
        scrollBehavior: MyCustomScrollBehavior(),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
