import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/navigation/screen_index_petugas.dart';

class PetugasNavigation extends StatefulWidget {
  const PetugasNavigation({super.key});

  @override
  State<PetugasNavigation> createState() => _PetugasNavigationState();
}

class _PetugasNavigationState extends State<PetugasNavigation> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screensPetugas().elementAt(_selectedIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          mainAxisAlignment: MainAxisAlignment.center,
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 5,
          activeColor: Colors.white,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: HexColor('204FA1'),
          color: HexColor('204FA1'),
          tabs: const [
            GButton(
              icon: Icons.home_rounded,
              text: 'Beranda',
            ),
            GButton(
              icon: Icons.monetization_on_rounded,
              text: 'Pembayaran',
            ),
            GButton(
              icon: EvaIcons.settings,
              text: 'Settings',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
