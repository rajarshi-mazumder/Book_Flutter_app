import 'package:book_frontend/models/books/author.dart';
import 'package:book_frontend/models/books/book.dart';
import 'package:book_frontend/models/books/category.dart';

List<Book> sampleBooks = [
  // The Lord of the Rings
  Book(
      title: "The Fellowship of the Ring",
      description:
          "A hobbit named Frodo inherits the One Ring, an evil artifact that threatens Middle-earth. He embarks on a quest to destroy it with the help of a fellowship.",
      categories: [
        Category(name: "Epic Fantasy"),
        Category(name: "Adventure"),
      ],
      author: Author(name: "J. R. R. Tolkien"),
      coverImgPath:
          "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg"),

  Book(
      title: "The Two Towers",
      description:
          "The Fellowship is broken, and Frodo and Sam continue their journey to Mordor. Aragorn, Legolas, and Gimli pursue Merry and Pippin who are captured by Orcs.",
      categories: [Category(name: "Epic Fantasy"), Category(name: "War")],
      author: Author(name: "J. R. R. Tolkien"),
      coverImgPath:
          "https://m.media-amazon.com/images/M/MV5BZTUxNzg3MDUtYjdmZi00ZDY1LTkyYTgtODlmOGY5N2RjYWUyXkEyXkFqcGdeQXVyMTA0MTM5NjI2._V1_FMjpg_UX1000_.jpg"),
  Book(
      title: "The Return of the King",
      description:
          "Frodo and Sam face their final challenge in Mordor, while the remaining members of the Fellowship reunite to fight Sauron's forces in a desperate battle.",
      categories: [Category(name: "Epic Fantasy"), Category(name: "Climax")],
      author: Author(name: "J. R. R. Tolkien"),
      coverImgPath:
          "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1654216226i/61215384.jpg"),

  // Harry Potter
  Book(
      title: "Harry Potter and the Philosopher's Stone",
      description:
          "An orphaned boy discovers he's a wizard and is whisked away to Hogwarts School of Witchcraft and Wizardry, where he finds friendship and faces a dark enemy.",
      categories: [
        Category(name: "Magic School"),
        Category(name: "Coming of Age")
      ],
      author: Author(name: "J. K. Rowling"),
      coverImgPath:
          "https://m.media-amazon.com/images/I/71XqqKTZz7L._AC_UF1000,1000_QL80_.jpg"),
  Book(
      title: "Harry Potter and the Chamber of Secrets",
      description:
          "Harry returns to Hogwarts for his second year, where he uncovers a dark secret from the school's past and battles a monstrous creature.",
      categories: [Category(name: "Magic School"), Category(name: "Mystery")],
      author: Author(name: "J. K. Rowling"),
      coverImgPath:
          "https://m.media-amazon.com/images/M/MV5BMjE0YjUzNDUtMjc5OS00MTU3LTgxMmUtODhkOThkMzdjNWI4XkEyXkFqcGdeQXVyMTA3MzQ4MTc0._V1_FMjpg_UX1000_.jpg"),
  Book(
      title: "Harry Potter and the Prisoner of Azkaban",
      description:
          "A dangerous escaped convict threatens Hogwarts, and Harry learns about his parents' past and a powerful connection to the dark wizard Voldemort.",
      categories: [
        Category(name: "Magic School"),
        Category(name: "Family Secrets")
      ],
      author: Author(name: "J. K. Rowling"),
      coverImgPath:
          "https://i5.walmartimages.com/seo/Harry-Potter-the-Prisoner-of-Azkaban-DVD_8d7cb6fa-cec5-457f-a8cb-f300e1ae229a.2b10ceaf2a6f357650af95c875d0c483.jpeg"),

  // Star Wars
  Book(
      title: "Star Wars: A New Hope",
      description:
          "In a galaxy far, far away, a group of rebels fight against the evil Galactic Empire led by Darth Vader. A young farm boy named Luke Skywalker joins the fight and becomes a hero.",
      categories: [Category(name: "Space Opera"), Category(name: "Rebellion")],
      author: Author(name: "George Lucas"),
      coverImgPath:
          "https://m.media-amazon.com/images/I/612h-jwI+EL._AC_UF1000,1000_QL80_.jpg"),
  Book(
      title: "Star Wars: The Empire Strikes Back",
      description:
          "The Rebel Alliance faces a desperate struggle against the Empire. Luke Skywalker seeks training from Jedi Master Yoda, while Darth Vader pursues him relentlessly.",
      categories: [Category(name: "Space Opera"), Category(name: "Darkness")],
      author: Author(name: "George Lucas"),
      coverImgPath:
          "https://m.media-amazon.com/images/I/711xW80aSGL._AC_UF1000,1000_QL80_.jpg"),
  Book(
      title: "Star Wars: Return of the Jedi",
      description:
          "Luke Skywalker confronts Darth Vader and the Emperor in a final battle to save the galaxy and restore peace to the Force.",
      categories: [Category(name: "Space Opera"), Category(name: "Redemption")],
      author: Author(name: "George Lucas"),
      coverImgPath: "path/to/return_jedi.jpg"),
];
