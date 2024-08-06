import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:flutter/material.dart';

mixin CollectionManagerMixin {
  List<Book> getBookForCollection(Collection collection, List<Book> allBooks) {
    // Check if collection categories are null and return an empty list if so
    if (collection.categories == null) {
      return [];
    }

    // Create a set of category IDs for quick lookup
    final categoryIds = collection.categories!.map((cat) => cat.id).toSet();

    // Filter books that have any category matching the collection's categories
    final filteredBooks = allBooks.where((book) {
      // Check if the book's categories are not null and contain any category matching the collection
      return book.categories
              ?.any((category) => categoryIds.contains(category.id)) ??
          false;
    }).toList();

    return filteredBooks;
  }

  List<Collection> generateRecommendedCollections(
      List<Map<String, dynamic>>? interestedCategories,
      List<Collection> allCollections) {
    if (interestedCategories == null || interestedCategories.isEmpty) {
      return [];
    }

    // Create a set of interested category IDs for quick lookup
    final interestedCategoryIds = interestedCategories
        .map((cat) => int.parse(cat['category_id']))
        .toSet();

    // Filter collections that have any matching category with the interested categories
    final recommendedCollections = allCollections.where((collection) {
      return collection.categories?.any(
              (category) => interestedCategoryIds.contains(category.id)) ??
          false;
    }).toList();

    return recommendedCollections;
  }
}
