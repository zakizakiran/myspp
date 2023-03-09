import 'dart:developer';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/controller/auth_controller.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nis = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController nisn = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController telp = TextEditingController();

  late List<DropdownMenuItem<String>> _dropDownMenuItems;

  String? _currentclass;
  String? tier;
  bool passenable = true; //track password value

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    nama.dispose();
    nis.dispose();
    nisn.dispose();
    telp.dispose();
    password.dispose();
    alamat.dispose();
    super.dispose();
  }

  RegExp regexPass =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_])$');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Builder(builder: (context) {
                    return IconButton(
                      onPressed: () {
                        showAlignedDialog(
                            context: context,
                            builder: _localDialogBuilder,
                            followerAnchor: Alignment.topRight,
                            targetAnchor: Alignment.bottomRight,
                            barrierColor: Colors.transparent);
                      },
                      icon: const Icon(Icons.info_outline_rounded),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Form(
                key: _formKey,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0)),
                  color: HexColor('0F0D35'),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Card(
                                  elevation: 0,
                                  color: HexColor('204FA1'),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Tambah Data Siswa',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: email,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.alternate_email_rounded,
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: HexColor('204FA1'), width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2)),
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                return null;
                              }),
                              controller: password,
                              obscureText: passenable,
                              decoration: InputDecoration(
                                  labelText: 'Kata Sandi',
                                  labelStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: HexColor('204FA1'), width: 2)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2)),
                                  suffixIcon: IconButton(
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      setState(() {
                                        if (passenable) {
                                          passenable = false;
                                        } else {
                                          passenable = true;
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      passenable == true
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                      color: Colors.white,
                                    ),
                                  )),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: nisn,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.tag_rounded,
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: HexColor('204FA1'), width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2)),
                                labelText: 'NISN',
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: nis,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.tag_rounded,
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: HexColor('204FA1'), width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2)),
                                labelText: 'NIS',
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: nama,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: HexColor('204FA1'), width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2)),
                                labelText: 'Nama',
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20.0),
                            DropdownButtonHideUnderline(
                              child: DropdownButtonFormField2(
                                decoration: const InputDecoration.collapsed(
                                    hintText: ''),
                                validator: (val) {
                                  if (val == null || val == '') {
                                    return 'Please Choose Your Grade!';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                buttonDecoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                                buttonHeight: 60,
                                buttonPadding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                items: _dropDownMenuItems,
                                value: _currentclass,
                                itemPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                dropdownMaxHeight: 150,
                                dropdownDecoration: BoxDecoration(
                                    color: HexColor('204FA1'),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                iconEnabledColor: Colors.white,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700),
                                dropdownElevation: 1,
                                scrollbarThickness: 5,
                                scrollbarAlwaysShow: true,
                                scrollbarRadius: const Radius.circular(40),
                                onChanged: (newValue) {
                                  setState(() {
                                    _currentclass = newValue;
                                    if (newValue!.startsWith('I', 3)) {
                                      tier = 'XIII';
                                    } else if (newValue.startsWith('I', 2)) {
                                      tier = 'XII';
                                    } else if (newValue.startsWith('I', 1)) {
                                      tier = 'XI';
                                    } else {
                                      tier = 'X';
                                    }
                                  });
                                  // Logger().i(tier);
                                },
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              controller: alamat,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  EvaIcons.pin,
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: HexColor('204FA1'), width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2)),
                                labelText: 'Alamat',
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: telp,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone_rounded,
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: HexColor('204FA1'), width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2)),
                                labelText: 'No Telepon',
                                hintText: 'contoh: 081234567890',
                                hintStyle: const TextStyle(color: Colors.grey),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              textInputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                          backgroundColor: HexColor('204FA1'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await ref
                                .read(authControllerProvider.notifier)
                                .emailPassSignUp(
                                    context,
                                    email.text,
                                    password.text,
                                    nama.text,
                                    _currentclass.toString(),
                                    telp.text,
                                    nis.text,
                                    nisn.text,
                                    alamat.text);
                            setState(() {});
                          } on FirebaseAuthException catch (e) {
                            log(e.message.toString());
                          }
                        }
                      },
                      child: const Text(
                        'Tambah Data',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  WidgetBuilder get _localDialogBuilder {
    return (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: HexColor('EAEBE7'))),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 18, color: Colors.black87),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 150,
                    child: const Text(
                        'Perhatikan saat anda akan mendaftar. Isilah data dengan benar.',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Quicksand',
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    };
  }
}
