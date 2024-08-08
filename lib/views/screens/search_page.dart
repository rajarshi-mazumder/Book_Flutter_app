import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/models/books/category.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/category_widgets/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Category> interestedCategories = [];

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    interestedCategories = userProvider.user?.interestedCategoriesList ?? [];
    return GestureDetector(
      onTap: () {
        // Unfocus the current text field to collapse the keyboard
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Text(interestedCategories.toString()),
          Container(
            height: 40,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                ...interestedCategories
                    .map((e) => Container(
                        margin: EdgeInsets.only(right: generalMargin),
                        child: GestureDetector(
                          child: CategoryTile(category: e),
                          onTap: () {},
                        )))
                    .toList()
              ],
            ),
          ),
          SearchFormWidget(onSearch: (val) {
            print("Searched string $val");
          })
        ],
      ),
    );
  }
}

class SearchFormWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchFormWidget({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchFormWidgetState createState() => _SearchFormWidgetState();
}

class _SearchFormWidgetState extends State<SearchFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter keyword',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a keyword';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSearch(_searchController.text);
                }
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
