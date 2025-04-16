import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Meal {
  Meal({
    required this.category,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    this.imagePath,
    String? id,
    this.discountedPrice,
  }) : id = id ?? uuid.v4();

  final String id;
  final String category;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String? imagePath;
  double? discountedPrice;

  // New getter for the effective price
  double get effectivePrice {
    return discountedPrice ?? price;
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'category': category,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath,
      'discountedPrice': discountedPrice,
    };
  }

  Meal copyWith({
    String? id,
    String? category,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    String? imagePath,
    double? discountedPrice,
  }) {
    return Meal(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
      discountedPrice: discountedPrice ?? this.discountedPrice,
    );
  }

  MealData toMealData() {
    return MealData(name: name, price: effectivePrice);
  }
}

class MealData {
  MealData({
    required this.name,
    required this.price,
  });

  final String name;
  final double price;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MealData &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}

Map<MealData, int> convertOrderedMeals(Map<Meal, int> orderedMeals) {
  final Map<MealData, int> newOrderedMeals = {};
  orderedMeals.forEach((meal, quantity) {
    MealData mealData = meal.toMealData();
    newOrderedMeals[mealData] = quantity;
  });
  return newOrderedMeals;
}