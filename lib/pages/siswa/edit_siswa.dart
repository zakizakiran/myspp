import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/controller/siswa_controller.dart';
import 'package:myspp_app/model/classname_list.dart';
import 'package:myspp_app/model/siswa.dart';
import 'package:myspp_app/pages/siswa/detail_siswa.dart';

class EditSiswa extends ConsumerStatefulWidget {
  final Siswa siswa;
  const EditSiswa({super.key, required this.siswa});

  @override
  ConsumerState<EditSiswa> createState() => _EditSiswaState();
}

class _EditSiswaState extends ConsumerState<EditSiswa> {
  int count = 0;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nis;
  late TextEditingController nama;
  late TextEditingController nisn;
  late TextEditingController alamat;
  late TextEditingController telp;

  late List<DropdownMenuItem<String>> _dropDownMenuItems;

  String? _currentclass;
  String? tier;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItem();
    _currentclass = widget.siswa.kelas;
    getAllSiswa();
    super.initState();
    nama = TextEditingController(text: widget.siswa.nama.toString());
    nis = TextEditingController(text: widget.siswa.nis.toString());
    nisn = TextEditingController(text: widget.siswa.nisn.toString());
    alamat = TextEditingController(text: widget.siswa.alamat.toString());
    telp = TextEditingController(text: widget.siswa.telp.toString());
  }

  Future<void> getAllSiswa() async {
    await ref.read(siswaControllerProvider.notifier).getSiswa();
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

  List className = Classname.className;

  List<DropdownMenuItem<String>> getDropDownMenuItem() {
    List<DropdownMenuItem<String>> items = [];
    for (String classes in className) {
      items.add(DropdownMenuItem(
        value: classes,
        child: Text(classes),
      ));
    }
    return items;
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
                      Navigator.pop(context);
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
                                        'Edit Data Siswa',
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
                              keyboardType: TextInputType.number,
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
                              keyboardType: TextInputType.number,
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
                              keyboardType: TextInputType.text,
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
                                scrollbarAlwaysShow: false,
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
                              keyboardType: TextInputType.phone,
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
                        try {
                          Siswa siswa = Siswa(
                              nisn: nisn.text,
                              nis: nis.text,
                              nama: nama.text,
                              alamat: alamat.text,
                              kelas: _currentclass,
                              telp: telp.text);
                          await ref
                              .read(siswaControllerProvider.notifier)
                              .updateSiswa(
                                  context: context,
                                  siswa: siswa,
                                  sid: widget.siswa.sid.toString());
                          setState(() {});
                          if (!mounted) return;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailSiswa(siswa: siswa)));
                          Snackbars().successSnackbars(context, 'Berhasil',
                              'Berhasil Mengubah Data Siswa');
                        } on FirebaseException catch (e) {
                          Snackbars().failedSnackbars(
                              context, 'Gagal', e.message.toString());
                        }
                      },
                      child: const Text(
                        'Edit Data',
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
                        'Perhatikan saat anda akan mengubah data siswa. Karena data akan disimpan dan tidak bisa mengembalikan data sebelumnya.',
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
