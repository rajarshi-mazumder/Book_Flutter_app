import 'package:book_frontend/controllers/books_management/collections_data_master.dart';
import 'package:book_frontend/controllers/s3_management/s3_image_getter_mixin.dart';
import 'package:book_frontend/controllers/s3_management/s3_management.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/collection.dart';
import 'package:book_frontend/services/cache_services/collections_cache_services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

mixin CollectionManagerMixin {
  static Future<String> collectionImageBaseLocalPath() async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    String filePath = '${directory?.path}/collection_images';
    return filePath;
  }

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

  Future<List<Collection>> downloadCollectionList() async {
    Map<String, dynamic>? collectionsListData =
        await CollectionsDataMaster.getCollections();

    List<Collection> collectionList = [];
    List? tempCollectionsList = collectionsListData?["collection_data"];

    if (tempCollectionsList != null) {
      for (var element in tempCollectionsList) {
        collectionList.add(Collection.fromMap(element));
      }
    }
    return collectionList;
  }

  List<Collection> sortCollectionsByUserInterest(List<Collection> collections,
      List<Map<String, dynamic>> interestedCategories) {
    if (interestedCategories.isEmpty) {
      return collections; // Return as is if there are no interested categories
    }

    // Extract category IDs from interested categories
    List<int> interestedCategoryIds = interestedCategories
        .map((category) => int.parse(category['category_id']))
        .toList();

    // Sort collections based on the number of matching categories
    collections.sort((a, b) {
      int aMatchCount = a.categories
              ?.where((category) => interestedCategoryIds.contains(category.id))
              .length ??
          0;
      int bMatchCount = b.categories
              ?.where((category) => interestedCategoryIds.contains(category.id))
              .length ??
          0;
      return bMatchCount.compareTo(aMatchCount); // Sort in descending order
    });

    return collections;
  }

  Future<String?> getImageForCollection(
      {required List<Collection> collections,
      required String collectionId}) async {
    for (Collection c in collections) {
      if (c.id == collectionId) {
        if (c.collectionImgLocalPath == null) {
          String basePath = await collectionImageBaseLocalPath();
          String savePath = "$basePath/${c.id}.jpg";
          String? preSignedUrl;

          preSignedUrl = await getPreSignedUrl(fileName: c.collectionImgPath);

          String? localFilePath = await fetchS3Object(
              imgPath: c.collectionImgPath,
              savePath: savePath,
              preSignedUrlStr: preSignedUrl);
          c.collectionImgLocalPath = localFilePath;
          if (localFilePath != null) {
            CollectionsCacheServices()
                .updateCollectionInHive(updatedCollection: c);
          }
          return c.collectionImgLocalPath;
        } else {
          return c.collectionImgLocalPath;
        }
      }
    }
    return null;
  }
}
