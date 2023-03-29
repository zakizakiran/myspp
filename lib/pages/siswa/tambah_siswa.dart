import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/controller/siswa_controller.dart';
import 'package:myspp_app/model/siswa.dart';

class TambahSiswa extends ConsumerStatefulWidget {
  const TambahSiswa({super.key});

  @override
  ConsumerState<TambahSiswa> createState() => _TambahSiswaState();
}

class _TambahSiswaState extends ConsumerState<TambahSiswa> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nis = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController nisn = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController telp = TextEditingController();

  String? _selectedJurusan;
  String? _selectedKelas;

  // Referensi collection "kelas" di Firestore
  final CollectionReference _kelasRef =
      FirebaseFirestore.instance.collection('kelas');

  bool passenable = true; //track password value

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nama.dispose();
    nis.dispose();
    nisn.dispose();
    telp.dispose();
    alamat.dispose();
    super.dispose();
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
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Mohon isi NISN!';
                                }
                                return null;
                              }),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: nisn,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.tag_rounded,
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
                                labelText: 'NISN',
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
                                  return 'Mohon isi NIS!';
                                }
                                return null;
                              }),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: nis,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.tag_rounded,
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
                                labelText: 'NIS',
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
                                  return 'Mohon isi nama!';
                                }
                                return null;
                              }),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: nama,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person_rounded,
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
                                labelText: 'Nama',
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20.0),
                            StreamBuilder<QuerySnapshot>(
                                stream: _kelasRef.snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  List<String> jurusanList = [];
                                  for (var doc in snapshot.data!.docs) {
                                    String jurusan = doc['jurusan'];
                                    if (!jurusanList.contains(jurusan)) {
                                      jurusanList.add(jurusan);
                                    }
                                  }
                                  return DropdownButtonFormField2(
                                    decoration: const InputDecoration.collapsed(
                                        hintText: ''),
                                    validator: (val) {
                                      if (val == null || val == '') {
                                        return 'Jurusan tidak boleh kosong';
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
                                      'Pilih Jurusan',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Quicksand'),
                                    ),
                                    value: _selectedJurusan,
                                    items: jurusanList.map((jurusan) {
                                      return DropdownMenuItem(
                                        value: jurusan,
                                        child: Text(
                                          jurusan,
                                          style: const TextStyle(
                                              fontFamily: 'Quicksand'),
                                        ),
                                      );
                                    }).toList(),
                                    itemPadding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    dropdownMaxHeight: 150,
                                    dropdownDecoration: BoxDecoration(
                                        color: HexColor('204FA1'),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    iconEnabledColor: Colors.white,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                    dropdownElevation: 1,
                                    scrollbarThickness: 5,
                                    scrollbarAlwaysShow: false,
                                    scrollbarRadius: const Radius.circular(40),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedJurusan = value;
                                        _selectedKelas =
                                            null; // reset kelas saat jurusan berubah
                                      });
                                    },
                                  );
                                }),
                            _selectedJurusan != null
                                ? StreamBuilder<QuerySnapshot>(
                                    stream: _kelasRef
                                        .where('jurusan',
                                            isEqualTo: _selectedJurusan)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      }
                                      List<dynamic> kelasList = [];
                                      for (var doc in snapshot.data!.docs) {
                                        kelasList.addAll(doc['nama_kelas']);
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: DropdownButtonFormField2(
                                          decoration:
                                              const InputDecoration.collapsed(
                                                  hintText: ''),
                                          validator: (val) {
                                            if (val == null || val == '') {
                                              return 'Mohon pilih kelas!';
                                            }
                                            return null;
                                          },
                                          isExpanded: true,
                                          buttonDecoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20.0)),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2)),
                                          buttonHeight: 60,
                                          buttonPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 14.0),
                                          hint: const Text(
                                            'Pilih Kelas',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Quicksand'),
                                          ),
                                          value: _selectedKelas,
                                          items: kelasList.map((jurusan) {
                                            return DropdownMenuItem(
                                              value: jurusan,
                                              child: Text(jurusan),
                                            );
                                          }).toList(),
                                          itemPadding: const EdgeInsets.only(
                                              left: 14, right: 14),
                                          dropdownMaxHeight: 150,
                                          dropdownDecoration: BoxDecoration(
                                              color: HexColor('204FA1'),
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                              _selectedKelas =
                                                  newValue.toString();
                                            });
                                          },
                                        ),
                                      );
                                    })
                                : const SizedBox(height: 0),
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
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: telp,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone_rounded,
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
                            Siswa siswa = Siswa(
                                nisn: nisn.text,
                                nis: nis.text,
                                nama: nama.text,
                                alamat: alamat.text,
                                kelas: _selectedKelas,
                                jurusan: _selectedJurusan,
                                telp: telp.text);
                            await ref
                                .read(siswaControllerProvider.notifier)
                                .tambahSiswa(context: context, siswa: siswa);
                            setState(() {});
                            if (!mounted) return;
                            Navigator.pop(context);
                            Snackbars().successSnackbars(
                                context, 'Berhasil', 'Berhasil Menambah Siswa');
                            Navigator.pop(context);
                          } on FirebaseException catch (e) {
                            Snackbars().failedSnackbars(
                                context, 'Gagal', e.message.toString());
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
                        'Perhatikan saat anda akan menambah data siswa. Isilah data dengan benar.',
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
