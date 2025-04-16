import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiter_app/providers/meals_provider.dart';
import 'package:waiter_app/widgets/commmon_scaffold.dart';
import 'package:waiter_app/widgets/custom_app_bar.dart';
import 'package:waiter_app/widgets/meal_card.dart';
import 'package:waiter_app/widgets/title_card.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() {
    return _StoreScreenState();
  }
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(mealsProvider.notifier).loadMeals();
  }

  @override
  Widget build(BuildContext context) {
    double cardSize = MediaQuery.of(context).size.width / 2 - 26;

    final meals = ref.watch(mealsProvider);

    final beverages =
        meals.where((meal) => meal.category == 'beverage').toList();
    final foods = meals.where((meal) => meal.category == 'food').toList();

    return CommonScaffold(
      appBar: CustomAppBar(
        title: 'Склад',
        onSearchPress: () {},
        showDrawerIcon: true,
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TitleCard(cardSize: cardSize, label: 'Напитки'),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: beverages.length,
                    itemBuilder: (ctx, index) => MealCard(
                      cardSize: cardSize,
                      meal: beverages[index],
                      onMealTap: (meal) {},
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                TitleCard(cardSize: cardSize, label: 'Блюда'),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: foods.length,
                    itemBuilder: (ctx, index) => MealCard(
                      cardSize: cardSize,
                      meal: foods[index],
                      onMealTap: (meal) {},
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
