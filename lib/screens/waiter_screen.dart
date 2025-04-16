import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiter_app/data/tables.dart';
import 'package:waiter_app/screens/sell_screen.dart';
import 'package:waiter_app/widgets/custom_app_bar.dart';
import 'package:waiter_app/widgets/table_card.dart';
import 'package:waiter_app/widgets/title_card.dart';

import '../model/order.dart';
import '../providers/orders_provider.dart';

class WaiterScreen extends ConsumerWidget {
  const WaiterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hall =
        tables.where((table) => table.place.name == 'Основной зал').toList();
    final terrace =
        tables.where((table) => table.place.name == 'Летка').toList();
    double cardSize = MediaQuery.of(context).size.width / 2 - 26;

    void openSellScreen(BuildContext context, int orderNumber) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellScreen(
              orderNumber: orderNumber), // Pass orderNumber to SellScreen
        ),
      );
    }

    void onTableCardTap(int tableId) {
      final newOrder = Order(
          tableId: tableId,
          orderedMeals: {}); // No need to specify order number
      ref.read(ordersProvider.notifier).addOrder(newOrder).then((orderNumber) {
        // This block will execute after the order is added and the order number is available
        if (context.mounted) {
          openSellScreen(context, orderNumber);
        }
        log("The generated order number is ${newOrder.number} in WaterScreen");
      });
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Выбор',
        onSearchPress: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  TitleCard(
                    cardSize: cardSize,
                    label: 'Основной зал',
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: hall.length,
                      itemBuilder: (ctx, index) => TableCard(
                        cardSize: cardSize,
                        table: hall[index],
                        onTableTap: onTableCardTap,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  TitleCard(cardSize: cardSize, label: 'Летка'),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: terrace.length,
                      itemBuilder: (ctx, index) => TableCard(
                        cardSize: cardSize,
                        table: terrace[index],
                        onTableTap: onTableCardTap,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
