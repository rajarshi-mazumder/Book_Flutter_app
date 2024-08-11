import 'package:flutter/material.dart';

class ErrorImageWidget extends StatelessWidget {
  const ErrorImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/Stack-of-Books-Clipart.jpg",
      fit: BoxFit.cover,
    );
  }
}
