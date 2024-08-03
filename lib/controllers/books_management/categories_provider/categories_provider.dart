import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_data_master.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_getter_mixin.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:flutter/material.dart';
import 'package:book_frontend/controllers/books_management/book_utilities/sort_utilities.dart';

class CategoriesProvider extends ChangeNotifier with CategoriesGetterMixin {
  List<Category> _categoriesList = [];

  List<Category> get categoriesList => _categoriesList;

  initActions(
      {required AppDataProvider appDataProvider,
      required UserProvider userProvider}) async {
    _categoriesList = await getCategories(
        appDataProvider: appDataProvider, userProvider: userProvider);
    sortCategories(
        categoriesInterested: userProvider.user?.interestedCategories);
    notifyListeners();
  }

  void sortCategories({List<Map<String, dynamic>>? categoriesInterested}) {
    _categoriesList = sortCategoriesByRelevance(
        categoriesInterested: categoriesInterested,
        categoriesList: _categoriesList);
    notifyListeners();
  }
}
