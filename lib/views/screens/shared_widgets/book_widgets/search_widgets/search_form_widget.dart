import 'package:book_frontend/theme/app_defaults.dart';
import 'package:flutter/material.dart';

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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: generalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter keyword',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter a keyword';
              //   }
              //   return null;
              // },
              onChanged: (val) {
                if (_formKey.currentState!.validate()) {
                  widget.onSearch(_searchController.text);
                }
              },
            ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     if (_formKey.currentState!.validate()) {
            //       widget.onSearch(_searchController.text);
            //     }
            //   },
            //   child: Text('Search'),
            // ),
          ],
        ),
      ),
    );
  }
}
