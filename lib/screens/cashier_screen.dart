import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiter_app/providers/orders_provider.dart';
import 'package:waiter_app/screens/reports_screen.dart';
import 'package:waiter_app/screens/shifts_screen.dart';
import 'package:waiter_app/widgets/commmon_scaffold.dart';

import '../widgets/custom_app_bar.dart';
import 'orders_screen.dart';

class CashierScreen extends ConsumerStatefulWidget {
  const CashierScreen({super.key});

  @override
  ConsumerState<CashierScreen> createState() {
    return CashierScreenState();
  }
}

class CashierScreenState extends ConsumerState<CashierScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      ref.read(ordersProvider.notifier).loadOrders();
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);

    Widget activePage = OrdersScreen(
      ordersList: orders,
    );
    var activePageTitle = 'Orders';

    if (_selectedPageIndex == 1) {
      activePage = const ReportsScreen();
      activePageTitle = 'Reports';
    }

    if (_selectedPageIndex == 2) {
      activePage = const ShiftsScreen();
      activePageTitle = 'Shifts';
    }

    return CommonScaffold(
      appBar: CustomAppBar(
        title: 'Кассир',
        onSearchPress: () {},
        showDrawerIcon: true,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Счета',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: 'Отчеты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Смена',
          ),
        ],
      ),
    );
  }
}
