import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/theme/app_defaults.dart';
import 'package:book_frontend/theme/icon_themes.dart';
import 'package:book_frontend/theme/text_themes.dart';
import 'package:flutter/material.dart';

class BookChapters extends StatefulWidget {
  final BookDetails bookDetails;

  BookChapters({required this.bookDetails});

  @override
  _BookChaptersState createState() => _BookChaptersState();
}

class _BookChaptersState extends State<BookChapters> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme appTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.bookDetails.chapters?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic>? chapter =
                  widget.bookDetails.chapters?[index];
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(generalMargin),
                padding: EdgeInsets.all(generalPadding * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Chapter ${index + 1}",
                            style: bookNameLargeStyle(appTextTheme)),
                        ElevatedButton(
                            onPressed: () {}, child: Text("Play audio"))
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 10),
                    Text(chapter?["content"] ?? ""),
                  ],
                ),
              );
            },
          ),
          Positioned(
            left: -5,
            top: 200,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: mediumIconSize),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),
          Positioned(
            right: -5,
            top: 200,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: mediumIconSize),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
