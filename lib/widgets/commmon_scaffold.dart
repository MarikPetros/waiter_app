import 'package:flutter/material.dart';
import 'package:waiter_app/screens/home_screen.dart';
import 'package:waiter_app/screens/store_screen.dart';
import 'package:waiter_app/screens/sell_screen.dart';
import 'package:waiter_app/screens/waiter_screen.dart';
import 'package:waiter_app/widgets/main_drawer.dart';
import 'package:intl/intl.dart';

import '../screens/cashier_screen.dart';

class CommonScaffold extends StatefulWidget {
  const CommonScaffold(
      {super.key,
      required this.appBar,
      required this.body,
      this.bottomNavigationBar});

  final PreferredSizeWidget appBar;
  final Widget body;
  final BottomNavigationBar? bottomNavigationBar;

  @override
  State<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  late String _formattedDate;

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'home') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(title: 'Home'),
        ),
      );
    }

    if (identifier == 'waiter_screen') {
      await Navigator.of(context).push(
        // TODO Don't use 'BuildContext's across async gaps
        MaterialPageRoute(
          builder: (ctx) => const WaiterScreen(),
        ),
      );
    }

    if (identifier == 'store_screen') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const StoreScreen(),
        ),
      );
    }

    if (identifier == 'cashier_screen') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const CashierScreen(),
        ),
      );
    }

    if (identifier == 'sell_regime') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const SellScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      drawer: MainDrawer(
          name: 'Иванов Иван Иванович',
          role: 'Сотрудник',
          time: _formattedDate,
          onSelectScreen: _setScreen),
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigationBar ?? const SizedBox(),
    );
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _formattedDate = DateFormat('dd.MM.yyyy HH.mm').format(now);
  }
}
