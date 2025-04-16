import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.onSearchPress,
    this.showDrawerIcon = false,
  });

  final String title;
  final void Function() onSearchPress;
  final bool showDrawerIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      title: Text(
        title,
      ),
      centerTitle: false,
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.primary,
      ),
      leading: showDrawerIcon
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            )
          : Platform.isIOS
              ? IconButton(
                  icon: const Icon(CupertinoIcons.back), // iPhone back icon
                  onPressed: () => Navigator.of(context).pop(),
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back), // Android back icon
                  onPressed: () => Navigator.of(context).pop(),
                ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          color: Theme.of(context).colorScheme.primary,
          onPressed: onSearchPress,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
