import 'package:book_frontend/controllers/books_management/books_provider.dart';
import 'package:book_frontend/controllers/user_management/user_provider.dart';
import 'package:book_frontend/data/book_details_list.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/book_details.dart';
import 'package:book_frontend/views/screens/shared_widgets/book_widgets/book_details_widget.dart';
import 'package:book_frontend/views/screens/shared_widgets/utility_widgets/loading_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsPage extends StatefulWidget {
  BookDetailsPage({super.key, required this.bookId, required this.book});
  String bookId;
  Book book;
  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Future<BookDetails?> fetchBookDetails(
      {required UserProvider userProvider,
      required BooksProvider booksProvider}) async {
    Book b = booksProvider.booksList
        .where((element) => element.bookId == widget.bookId)
        .first;
    if (b.bookDetails == null) {
      booksProvider.getBookDetails(
          userProvider: userProvider, book: widget.book);
    }

    return b.bookDetails;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    BooksProvider booksProvider = context.watch<BooksProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Summarizer"),
      ),
      body: FutureBuilder<BookDetails?>(
        future: fetchBookDetails(
            userProvider: userProvider, booksProvider: booksProvider),
        builder: (BuildContext context, AsyncSnapshot<BookDetails?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
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
