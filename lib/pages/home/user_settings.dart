// ignore_for_file: prefer_const_constructors

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
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
    final currentUser = ref.watch(authControllerProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                children: const [
                  Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentUser.nama.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                currentUser.nisn.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                color: HexColor('204FA1'),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  child: Text(
                    currentUser.email.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Divider(
                thickness: 2.0,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'General',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  color: HexColor('204FA1'),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: HexColor('204FA1'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: HexColor('204FA1'),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  'Hapus Akun',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              EvaIcons.trash2Outline,
                              color: Colors.redAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
