import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:waiter_app/model/meal.dart';
import 'package:waiter_app/providers/meals_provider.dart';

void main() {
  group('MealsDatabaseHelper', () {
    late MealsDatabaseHelper mealsDatabaseHelper;

    setUp(() async {
      // Initialize a temporary database for testing
      sqflite.Sqflite.devSetDebugModeOn(true);
      final databasesPath = await sqflite.getDatabasesPath();
      final path = join(databasesPath, 'test_meals.db');
      mealsDatabaseHelper = MealsDatabaseHelper.instance;
      await mealsDatabaseHelper.deleteDatabase(); // Ensure a clean database
      // await mealsDatabaseHelper.initDatabase(path);
      mealsDatabaseHelper = MealsDatabaseHelper.instance;
    });

    tearDown(() async {
      // Close and delete the temporary database
      // await mealsDatabaseHelper.closeDatabase(); tesnenq hly petq a?
      await mealsDatabaseHelper.deleteDatabase();
    });

    test('insertMeal should insert a meal into the database', () async {
      final meal = Meal(
        id: '1',
        category: 'food',
        name: 'Spaghetti',
        imageUrl: '...',
        price: 1500,
        quantity: 7,
      );

      await mealsDatabaseHelper.insertMealPublicly(meal);

      // final meals = await mealsDatabaseHelper.getMeals();
      final db = await MealsDatabaseHelper.instance.database;
      List<Map<String, dynamic>> maps = await db.query('meals');
      final meals = List.generate(maps.length, (i) {
        return Meal(
          id: maps[i]['_id'],
          category: maps[i]['category'],
          name: maps[i]['name'],
          imageUrl: maps[i]['imageUrl'],
          price: maps[i]['price'],
          quantity: maps[i]['quantity'],
          imagePath: maps[i]['imagePath'],
          discountedPrice: maps[i]['discountedPrice'],
        );
      });

      expect(meals.length, 1);
      expect(meals[0], meal);
    });

    // Add more tests for other database operations
  });
}