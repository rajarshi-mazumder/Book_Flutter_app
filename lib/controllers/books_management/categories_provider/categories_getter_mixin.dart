import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_data_master.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/services/cache_services/app_cache_services.dart';
import 'package:book_frontend/services/cache_services/categories_cache_service.dart';
import 'package:flutter/material.dart';

mixin CategoriesGetterMixin on ChangeNotifier {
  Future<List<Category>> getCategories(
      {required AppDataProvider appDataProvider,
      required UserProvider userProvider}) async {
    List<Category> categoriesList = [];
    bool needToDownloadCategoriesList =
        appDataProvider.checkIfShouldFetchCategories();

    // if (!hasNext) {
    //   return;
    // }
    if (needToDownloadCategoriesList) {
      print("Need to download categories- downloading and caching");

      categoriesList = await downloadCategoriesList(userProvider: userProvider);

      // delete existing categoriesList cache and write new cache
      CategoriesCacheServices().deleteCategoriesListCache();
      CategoriesCacheServices()
          .writeAllCategories(categoriesList: categoriesList)
          .then((_) {
        AppCacheServices().writeLastCategoriesListVersion(
            categoriesListVersion: appDataProvider.lastCategoriesListVersion);
      });
    } else {
      print("No need to download categories- reading from cache");

      categoriesList = await CategoriesCacheServices().readAllCategories();
    }
    return categoriesList;
  }

  Future<List<Category>> downloadCategoriesList(
      {required UserProvider userProvider}) async {
    List? tempCategoriesList = [];
    List<Category> categoriesList = [];
    tempCategoriesList =
        await CategoriesDataMaster.getCategories(userProvider: userProvider);
    tempCategoriesList?.forEach((element) {
      categoriesList.add(Category.fromMap(element));
    });

    return categoriesList;
  }
}
