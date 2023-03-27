import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/controller/pembayaran_controller.dart';
import 'package:myspp_app/model/pembayaran.dart';

class PembayaranWidget extends ConsumerStatefulWidget {
  const PembayaranWidget({super.key});

  @override
  ConsumerState<PembayaranWidget> createState() => _PembayaranWidgetState();
}

class _PembayaranWidgetState extends ConsumerState<PembayaranWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _totalTagihan = TextEditingController();
  final TextEditingController test = TextEditingController();

  String? _currentSiswa;
  String? _currentEmail;
  String? _selectedMonth;
  int? _selectedYear;
  final int _startYear = DateTime.now().year;
  final int _endYear = DateTime.now().year + 20;

  // Referensi collection "pengguna" di Firestore
  final _penggunaRef = FirebaseFirestore.instance
      .collection('pengguna')
      .where('level', isEqualTo: 'Siswa');

  final List<String> _monthsList = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authControllerProvider);

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
                                  style: TextStyle(color: Colors.grey[400]),
                                  controller: _nisnController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.tag_rounded,
                                      color: Colors.grey,
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

                          // Bulan Bayar Dropdown //
                          DropdownButtonFormField2<String>(
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            validator: (val) {
                              if (val == null || val == '') {
                                return 'Pilih Bulan!';
                              }
                              return null;
                            },
                            isExpanded: true,
                            buttonDecoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            buttonHeight: 60,
                            buttonPadding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            hint: const Text(
                              'Pilih Bulan',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: _selectedMonth,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedMonth = newValue!;
                              });
                            },
                            iconEnabledColor: Colors.white,
                            selectedItemBuilder: (BuildContext ctx) {
                              return _monthsList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Quicksand'),
                                  ),
                                );
                              }).toList();
                            },
                            itemPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            dropdownMaxHeight: 150,
                            dropdownDecoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            items: _monthsList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20.0),

                          // Tahun Bayar Dropdown //
                          DropdownButtonFormField2<int>(
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            validator: (val) {
                              if (val == null) {
                                return 'Pilih Tahun!';
                              }
                              return null;
                            },
                            isExpanded: true,
                            buttonDecoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            buttonHeight: 60,
                            buttonPadding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            hint: const Text(
                              'Pilih Tahun',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: _selectedYear,
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedYear = newValue!;
                              });
                            },
                            iconEnabledColor: Colors.white,
                            selectedItemBuilder: (BuildContext ctx) {
                              return List<int>.generate(
                                      _endYear - _startYear + 1,
                                      (i) => i + _startYear)
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                    value.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList();
                            },
                            itemPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            dropdownMaxHeight: 150,
                            dropdownDecoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            items: List<int>.generate(_endYear - _startYear + 1,
                                    (i) => i + _startYear)
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20.0),

                          TextFormField(
                            validator: (value) {},
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: _totalTagihan,
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
                              labelText: 'Total Tagihan',
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
                                  onPressed: () async {
                                    try {
                                      Pembayaran pembayaran = Pembayaran(
                                        namaSiswa: _currentSiswa,
                                        emailSiswa: _currentEmail,
                                        nisn: _nisnController.text,
                                        bulanBayar: _selectedMonth,
                                        tahunBayar: _selectedYear,
                                        namaPetugas: currentUser.nama,
                                        jmlTagihan:
                                            int.tryParse(_totalTagihan.text),
                                      );
                                      await ref
                                          .read(pembayaranControllerProvider
                                              .notifier)
                                          .tambahPembayaran(
                                              context: context,
                                              pembayaran: pembayaran);
                                      if (!mounted) return;
                                      Navigator.pop(context);
                                      Snackbars().successSnackbars(
                                          context,
                                          'Berhasil',
                                          'Berhasil Melakukan Pembayaran!');
                                    } on FirebaseException catch (e) {
                                      Logger().i(e.message);
                                    }
                                  },
                                  child: Text(
                                    'Buat Tagihan',
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
