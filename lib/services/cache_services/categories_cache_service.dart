import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoriesCacheServices {
  Box<Category>? _allCategoriesBox;

  CategoriesCacheServices() {
    _allCategoriesBox = Hive.box('all_categories');
  }

  Future<void> writeAllCategories(
      {required List<Category> categoriesList}) async {
    // Iterate through the list of categories and add each category to the box
    for (var category in categoriesList) {
      try {
        await _allCategoriesBox?.add(category);
      } catch (e) {
        print("category ${category.name} already exists");
      }
    }
    readAllCategories();
  }

  Future<List<Category>> readAllCategories() async {
    // Retrieve all categories from the box and convert them to a list
    List<Category>? categories = _allCategoriesBox?.values.toList();

    return categories ?? [];
  }

  deleteCategoriesListCache() {
    _allCategoriesBox?.clear();
  }
}
