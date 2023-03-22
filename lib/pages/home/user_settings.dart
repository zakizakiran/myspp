import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/controller/auth_controller.dart';

class UserSettings extends ConsumerStatefulWidget {
  const UserSettings({super.key});

  @override
  ConsumerState<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   'Settings',
        //   style: TextStyle(
        //     fontSize: 22.0,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: HexColor("FAB464")),
                  width: 50,
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await ref.read(authControllerProvider.notifier).signOut(context);
            } on FirebaseAuthException {
              AnimatedSnackBar.rectangle(
                'Logout Failed',
                '',
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              );
            }
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
