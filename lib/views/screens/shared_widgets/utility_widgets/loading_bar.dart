import 'package:book_frontend/theme/icon_themes.dart';
import 'package:book_frontend/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIcon extends StatelessWidget {
  LoadingIcon({super.key, this.iconSize});
  double? iconSize;
  @override
  Widget build(BuildContext context) {
    iconSize = iconSize ?? largeIconSize;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: LoadingAnimationWidget.flickr(
              leftDotColor: primaryColor,
              rightDotColor: secondaryColor,
              size: iconSize!),
        ),
      ],
    );
  }
}
