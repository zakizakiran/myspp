import 'dart:developer';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/components/get_role.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/controller/siswa_controller.dart';
import 'package:myspp_app/model/siswa.dart';
import 'package:myspp_app/pages/pengguna/data_pengguna.dart';

class TambahPenggunaPetugas extends ConsumerStatefulWidget {
  final Siswa? siswa;
  const TambahPenggunaPetugas({super.key, required this.siswa});

  @override
  ConsumerState<TambahPenggunaPetugas> createState() =>
      _TambahPenggunaPetugasState();
}

class _TambahPenggunaPetugasState extends ConsumerState<TambahPenggunaPetugas> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late TextEditingController nama;
  late TextEditingController alamat;
  late TextEditingController telp;

  late List<DropdownMenuItem<String>> _dropDownMenuItems;

  String? _currentRole;
  bool passenable = true; //track password value

  @override
  void initState() {
    _dropDownMenuItems = getDropdownMenuItem();
    _currentRole = _dropDownMenuItems[0].value!;
    getAllSiswa();
    super.initState();
    nama = TextEditingController(text: widget.siswa!.nama.toString());
    alamat = TextEditingController(text: widget.siswa!.alamat.toString());
    telp = TextEditingController(text: widget.siswa!.telp.toString());
  }

  Future<void> getAllSiswa() async {
    await ref.read(siswaControllerProvider.notifier).getSiswa();
  }

  @override
  void dispose() {
    email.dispose();
    nama.dispose();
    telp.dispose();
    password.dispose();
    alamat.dispose();
    super.dispose();
  }

  List roles = RoleName.roleName;

  List<DropdownMenuItem<String>> getDropdownMenuItem() {
    List<DropdownMenuItem<String>> items = [];
    for (String item in roles) {
      items.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
    return items;
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
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
                                        'Mendaftar Pengguna Baru',
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
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Mohon isi email!';
                                }
                                return null;
                              }),
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: email,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.alternate_email_rounded,
                                  color: Colors.white,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2)),
                                errorStyle:
                                    const TextStyle(color: Colors.white),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2)),
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
                              keyboardType: TextInputType.emailAddress,
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
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2)),
                                  errorStyle:
                                      const TextStyle(color: Colors.white),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2)),
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
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Mohon isi nama!';
                                }
                                return null;
                              }),
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
                            TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Mohon isi alamat!';
                                }
                                return null;
                              }),
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
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Mohon isi nomor telepon!';
                                }
                                return null;
                              }),
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
                              keyboardType: TextInputType.phone,
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
                                .registerSiswa(
                                  context,
                                  email.text,
                                  password.text,
                                  nama.text,
                                  telp.text,
                                  alamat.text,
                                  sid: widget.siswa!.sid.toString(),
                                  nisn: widget.siswa!.nisn.toString(),
                                  kelas: widget.siswa!.kelas.toString(),
                                  _currentRole.toString(),
                                );
                            if (!mounted) return;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DataPengguna()));
                            setState(() {});
                          } on FirebaseAuthException catch (e) {
                            log(e.message.toString());
                          }
                        }
                      },
                      child: const Text(
                        'Tambah Pengguna',
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
