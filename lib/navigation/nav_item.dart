import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

List<PersistentBottomNavBarItem>? navbarItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.house_fill),
      title: 'Home',
      textStyle: const TextStyle(fontFamily: 'Quicksand', fontSize: 10.0),
      inactiveColorPrimary: HexColor('0F0D35'),
      activeColorPrimary: HexColor('204FA1'),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.gear),
      title: 'Settings',
      textStyle: const TextStyle(fontFamily: 'Quicksand', fontSize: 10.0),
      inactiveColorPrimary: HexColor('0F0D35'),
      activeColorPrimary: HexColor('204FA1'),
    ),
  ];
}
