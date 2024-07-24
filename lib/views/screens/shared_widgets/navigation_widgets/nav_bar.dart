import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/services/cache_services/user_cache_services.dart';
import 'package:book_frontend/views/screens/authentication/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  Navbar(
      {super.key,
      this.title = "Book Summarizer",
      this.additionalActionWidgets});
  final String title;
  List<Widget>? additionalActionWidgets;
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return AppBar(
      title: Text(title),
      actions: [
        ...additionalActionWidgets ?? [],
        IconButton(
            onPressed: () {
              UserCacheServices().deleteUserStoredData();
            },
            icon: Icon(Icons.delete)),
        IconButton(
            onPressed: () {
              UserCacheServices().writeUserInterestedCategories(categoryIdToSave: "3");
            },
            icon: Icon(Icons.add)),
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
