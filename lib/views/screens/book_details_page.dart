import 'package:book_frontend/data/book_details_list.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/book_details_widget.dart';
import 'package:book_frontend/views/screens/shared_widgets/utility_widgets/loading_bar.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  BookDetailsPage({super.key, required this.bookId, required this.book});
  String bookId;
  Book book;
  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Future<BookDetails?> fetchBookDetails() async {
    await Future.delayed(const Duration(milliseconds: 100));
    var temp =
        bookDetailsList.where((element) => element.bookId == widget.bookId);
    if (temp.isNotEmpty) {
      return temp.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Summarizer"),
      ),
      body: FutureBuilder<BookDetails?>(
        future: fetchBookDetails(),
        builder: (BuildContext context, AsyncSnapshot<BookDetails?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.chapters != null) {
              return BookDetailsWidget(
                  bookDetails: snapshot.data!, book: widget.book);
            } else {
              return const NoContentWidget();
            }
          } else {
            return const NoContentWidget();
          }
        },
      ),
    );
  }
}

class NoContentWidget extends StatelessWidget {
  const NoContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingIcon(),
          ],
        ));
  }
}
