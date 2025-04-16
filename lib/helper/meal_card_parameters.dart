import 'dart:ui';

class MealCardParameters {
  MealCardParameters({
    required this.cardSize,
    required this.columnSizeBoxHeight,
    required this.imageFlex,
    required this.bottomTextFlex,
    required this.priceFont,
    required this.storeFont,
    required this.nameFont,
  });

  final double cardSize;
  final double columnSizeBoxHeight;
  final int imageFlex;
  final int bottomTextFlex;
  final FontStyle priceFont;
  final FontStyle storeFont;
  final FontStyle nameFont;

}
