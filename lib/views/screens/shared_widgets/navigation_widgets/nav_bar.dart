import 'package:book_frontend/controllers/books_management/book_provider/books_provider.dart';
import 'package:book_frontend/controllers/s3_management/s3_management.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/services/cache_services/book_cache_services.dart';
import 'package:book_frontend/services/cache_services/cache_services.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';
import 'package:book_frontend/views/screens/authentication/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar(
      {super.key,
      this.title = "Book Summarizer",
      this.additionalActionWidgets});

  final String title;
  final List<Widget>? additionalActionWidgets;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    BooksProvider booksProvider = Provider.of<BooksProvider>(context);
    return AppBar(
      title: Text(title),
      actions: [
        ...additionalActionWidgets ?? [],
        IconButton(
            onPressed: () {
              deleteAllCachedData(booksProvider: booksProvider);
            },
            icon: Icon(Icons.delete)),
        IconButton(
            onPressed: () {
              downloadFile(
                  "https://book-storage-test-01.s3.ap-northeast-1.amazonaws.com/");
            },
            icon: Icon(Icons.download)),
        IconButton(
            onPressed: () async {
              await userProvider.logout().then((value) =>
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage())));
            },
            icon: const Icon(Icons.logout)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 50);
}
