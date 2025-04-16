import 'dart:convert';

import 'meal.dart';

class Order {
  Order({
    this.number,
    required this.tableId,
    required this.orderedMeals,
    DateTime? creationDate,
  }): creationDate = creationDate ?? DateTime.now();

  int? number;
  final int tableId;
  final DateTime creationDate;
  Map<MealData, int> orderedMeals;

  double get orderPrice {
    double totalPrice = 0;
    orderedMeals.forEach((mealData, quantity) {
      totalPrice += mealData.price * quantity;
    });
    return totalPrice;
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'tableId': tableId,
      'date': creationDate.toIso8601String(),
      'orderedMeals': _serializeOrderedMeals(orderedMeals),
    };
  }

// Helper method to serialize orderedMeals for the database
  static String _serializeOrderedMeals(Map<MealData, int> orderedMeals) {
    final Map<String, dynamic> mealMap = {};
    orderedMeals.forEach((mealData, quantity) {
      mealMap[mealData.name] = {
        'quantity': quantity,
        'meal_price': mealData.price,
        // Add other properties of MealData if needed
      };
    });
    return jsonEncode(mealMap);
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      number: map['number'],
      tableId: map['tableId'],
      creationDate: DateTime.parse(map['date']),
      orderedMeals: _parseOrderedMeals(map['orderedMeals']),
    );
  }

// Helper method to parse orderedMeals from the database
  static Map<MealData, int> _parseOrderedMeals(String orderedMealsString) {
    final Map<String, dynamic> mealMap = jsonDecode(orderedMealsString);
    final Map<MealData, int> orderedMeals = {};
    mealMap.forEach((mealName, mealData) {
      final meal = MealData(name: mealName, price: mealData['meal_price']); // Create MealData object
      orderedMeals[meal] = mealData['quantity'];
    });
    return orderedMeals;
  }

  // // Add a method to update the order in the database
  // void updateOrder(Map<MealData, int> newOrderedMeals) {
  //   orderedMeals = newOrderedMeals;
  // }
  // // Add a method to update the order in the database
  // void updateOrderNumber(int newNumber) {
  //   number = newNumber;
  // }
}


