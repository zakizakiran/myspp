import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

class Student {
  final String email;
  final String nisn;

  Student({required this.email, required this.nisn});
}

class PembayaranWidget extends ConsumerStatefulWidget {
  const PembayaranWidget({super.key});

  @override
  ConsumerState<PembayaranWidget> createState() => _PembayaranWidgetState();
}

class _PembayaranWidgetState extends ConsumerState<PembayaranWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _totalBayar = TextEditingController();

  String? _currentSiswa;
  String? _currentEmail;

  // Referensi collection "kelas" di Firestore
  final _penggunaRef = FirebaseFirestore.instance
      .collection('pengguna')
      .where('level', isEqualTo: 'Siswa');

  final List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _students.add(Student(email: doc['email'], nisn: doc['nisn']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: HexColor('204FA1'),
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20.0))),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream: _penggunaRef.snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                List<String> namaList = [];
                                for (var doc in snapshot.data!.docs) {
                                  String nama = doc['nama'];
                                  if (!namaList.contains(nama)) {
                                    namaList.add(nama);
                                  }
                                }
                                return DropdownButtonFormField2(
                                  decoration: const InputDecoration.collapsed(
                                      hintText: ''),
                                  validator: (val) {
                                    if (val == null || val == '') {
                                      return 'Siswa tidak boleh kosong';
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
                                  hint: const Text(
                                    'Pilih Siswa',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Quicksand'),
                                  ),
                                  value: _currentSiswa,
                                  selectedItemBuilder: (BuildContext ctx) {
                                    return namaList.map((nama) {
                                      return DropdownMenuItem(
                                        value: nama,
                                        child: Text(
                                          nama,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Quicksand'),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  items: namaList.map((nama) {
                                    return DropdownMenuItem(
                                      value: nama,
                                      child: Text(
                                        nama,
                                        style: const TextStyle(
                                            fontFamily: 'Quicksand'),
                                      ),
                                    );
                                  }).toList(),
                                  itemPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  dropdownMaxHeight: 150,
                                  dropdownDecoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  iconEnabledColor: Colors.white,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                  dropdownElevation: 1,
                                  scrollbarThickness: 5,
                                  scrollbarAlwaysShow: false,
                                  scrollbarRadius: const Radius.circular(40),
                                  onChanged: (value) {
                                    setState(() {
                                      _currentSiswa = value;
                                      _currentEmail =
                                          null; // reset kelas saat jurusan berubah
                                    });
                                  },
                                );
                              }),
                          _currentSiswa != null
                              ? StreamBuilder<QuerySnapshot>(
                                  stream: _penggunaRef
                                      .where('nama', isEqualTo: _currentSiswa)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }
                                    List<dynamic> emailList = [];
                                    for (var doc in snapshot.data!.docs) {
                                      emailList.add(doc['email']);
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: DropdownButtonFormField2(
                                        decoration:
                                            const InputDecoration.collapsed(
                                                hintText: ''),
                                        validator: (val) {
                                          if (val == null || val == '') {
                                            return 'Pilih Akun!';
                                          }
                                          return null;
                                        },
                                        isExpanded: true,
                                        buttonDecoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20.0)),
                                            border: Border.all(
                                                color: Colors.white, width: 2)),
                                        buttonHeight: 60,
                                        buttonPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 14.0),
                                        hint: const Text(
                                          'Pilih Akun',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Quicksand'),
                                        ),
                                        selectedItemBuilder:
                                            (BuildContext ctx) {
                                          return emailList.map((nama) {
                                            return DropdownMenuItem(
                                              value: nama,
                                              child: Text(
                                                nama,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Quicksand'),
                                              ),
                                            );
                                          }).toList();
                                        },
                                        value: _currentEmail,
                                        items: emailList.map((nama) {
                                          return DropdownMenuItem(
                                            value: nama,
                                            child: Text(
                                              nama,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Quicksand'),
                                            ),
                                          );
                                        }).toList(),
                                        itemPadding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        dropdownMaxHeight: 150,
                                        dropdownDecoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        iconEnabledColor: Colors.white,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                        dropdownElevation: 1,
                                        scrollbarThickness: 5,
                                        scrollbarAlwaysShow: false,
                                        scrollbarRadius:
                                            const Radius.circular(40),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _currentEmail = newValue.toString();
                                            _nisnController.text = snapshot
                                                .data!.docs
                                                .firstWhere((doc) =>
                                                    doc['email'] ==
                                                    _currentEmail)['nisn']
                                                .toString();
                                          });
                                        },
                                      ),
                                    );
                                  })
                              : const SizedBox(height: 0),
                          const SizedBox(height: 20.0),
                          _currentEmail != null
                              ? TextFormField(
                                  enabled: false,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  controller: _nisnController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.tag_rounded,
                                      color: Colors.white,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 2)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 2)),
                                    labelText: 'NISN',
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  textInputAction: TextInputAction.next,
                                )
                              : const SizedBox(height: 0),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            validator: (value) {},
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: _totalBayar,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.attach_money_rounded,
                                color: Colors.white,
                              ),
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2)),
                              labelText: 'Total Bayar',
                              labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 40.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.all(12.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0))),
                                  onPressed: () {},
                                  child: Text(
                                    'Bayar',
                                    style: TextStyle(
                                        color: HexColor('204FA1'),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
