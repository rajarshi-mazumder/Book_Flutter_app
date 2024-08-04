import 'package:book_frontend/controllers/app_data_management/app_data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void setAppData(Map<String, dynamic>? appData, BuildContext context) {
  if (appData == null) return;
  AppDataProvider appDataProvider =
      Provider.of<AppDataProvider>(context, listen: false);

  appDataProvider.updateLastBooksListVersion(
      newBooksListVersion: appData["last_books_list_version"] ?? "1.0");

  appDataProvider.updateLastCategoriesListVersion(
      newCategoriesListVersion:
          appData["last_categories_list_version"] ?? "1.0");

  appDataProvider.updateLastCollectionsListVersion(
      newCollectionsListVersion:
          appData["last_collections_list_version"] ?? "1.0");
}
