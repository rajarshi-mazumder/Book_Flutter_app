import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/books_management/categories_provider/categories_provider.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/models/users/app_user.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';

mixin UserCategoryOperationsMixin {
  List<Category> generateInterestedCategoriesList(
      List<Map<String, dynamic>> interestedCategories,
      List<Category> allCategories) {
    // Extract category IDs from the interested categories list
    List<String> interestedCategoryIds = interestedCategories
        .map((category) => category['category_id'].toString())
        .toList();

    // Filter allCategories to find matching ones based on IDs
    List<Category> matchedCategories = allCategories.where((category) {
      return interestedCategoryIds.contains(category.id.toString());
    }).toList();

    return matchedCategories;
  }

  List<Map<String, dynamic>>? addUserInterestedCategoriesList(
      {List<Map<String, dynamic>>? interestedCategories,
      required Book book,
      required BooksProvider booksProvider,
      required CategoriesProvider categoriesProvider}) {
    if (book.categories != null) {
      for (Category cat in book.categories!) {
        bool flag = false;
        if (interestedCategories != null) {
          for (var c in interestedCategories!) {
            if (c["category_id"] == cat.id.toString()) {
              flag = true;
              break;
            }
          }
        }

        if (!flag) {
          interestedCategories
              ?.add({"category_id": cat.id, "interested_date": DateTime.now()});

          UserCacheServices().writeUserInterestedCategories(
              categoryIdToSave: cat.id.toString());
        }
      }
    }
    return interestedCategories;
  }
}
