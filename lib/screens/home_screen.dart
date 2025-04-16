import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiter_app/providers/meals_provider.dart';
import 'package:waiter_app/widgets/commmon_scaffold.dart';
import 'package:waiter_app/widgets/custom_app_bar.dart';

import '../providers/orders_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CustomAppBar(
        title: widget.title,
        onSearchPress: () {},
        showDrawerIcon: true,
      ),
      body: Container(),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkAndPopulateDatabase();
    ref.read(ordersProvider.notifier).loadOrders();
  }

  Future<void> _checkAndPopulateDatabase() async {
    final databaseExists = await MealsDatabaseHelper.instance.databaseExists();
    if (!databaseExists) {
      ref.read(mealsProvider.notifier).populateMealsDatabase(context);
    }
  }
}
