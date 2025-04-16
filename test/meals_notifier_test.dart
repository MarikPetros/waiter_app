import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:waiter_app/model/meal.dart';
import 'package:waiter_app/providers/meals_provider.dart';

class MockMealsDatabaseHelper extends Mock implements MealsDatabaseHelper {}

void main() {
  group('MealsNotifier', () {
    late MealsNotifier mealsNotifier;
    late MockMealsDatabaseHelper mockMealsDatabaseHelper;

    setUp(() {
      mockMealsDatabaseHelper = MockMealsDatabaseHelper();
      mealsNotifier = MealsNotifier.withDatabase(mockMealsDatabaseHelper);

      // Add this stub for insertMeal
      // when(mockMealsDatabaseHelper.insertMealPublicly(any)).thenAnswer((_) async => 1);
    });

    test('addMeal should add a meal to the list', () async {
      final meal = Meal(
        id: '1',
        category: 'food',
        name: 'Spaghetti',
        imageUrl: '...',
        price: 1500,
        quantity: 7,
      );

      when(mockMealsDatabaseHelper.insertMealPublicly(meal)).thenAnswer((_) async => 1);

      // await mealsNotifier.addMeal(meal);

      expect(mealsNotifier.state.length, 1);
      expect(mealsNotifier.state[0], meal);
    });

    // Add more tests for other methods in MealsNotifier
  });
}