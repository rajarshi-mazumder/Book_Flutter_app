import 'package:book_frontend/controllers/books_management/categories_data_master.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:flutter/material.dart';
import 'book_utilities/sort_utitlities';

class CategoriesProvider extends ChangeNotifier {
  List<Category> _categoriesList = [];

  List<Category> get categoriesList => _categoriesList;

  getCategories({required UserProvider userProvider}) async {
    List? categoriesList =
        await CategoriesDataMaster.getCategories(userProvider: userProvider);
    categoriesList?.forEach((element) {
      _categoriesList.add(Category.fromMap(element));
    });

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
