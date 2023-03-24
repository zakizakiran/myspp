import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myspp_app/components/animations/showup.dart';
import 'package:myspp_app/components/skeleton_container.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/controller/siswa_controller.dart';
import 'package:myspp_app/model/siswa.dart';
import 'package:myspp_app/pages/siswa/detail_siswa.dart';
import 'package:myspp_app/pages/siswa/edit_siswa.dart';
import 'package:myspp_app/pages/siswa/tambah_siswa.dart';

class DataSiswa extends ConsumerStatefulWidget {
  const DataSiswa({super.key});

  @override
  ConsumerState<DataSiswa> createState() => _DataSiswaState();
}

class _DataSiswaState extends ConsumerState<DataSiswa> {
  TextEditingController search = TextEditingController();
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    getAllSiswa();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
    getAllSiswa();
  }

  List<Siswa> siswaResult = [];

  Future<void> getAllSiswa() async {
    await ref.read(siswaControllerProvider.notifier).getSiswa();
  }

  Future loadData() async {
    setState(() {
      isloading = true;
    });

    await Future.delayed(
      const Duration(seconds: 1),
      () {
        if (mounted) {
          setState(() {
            isloading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var siswas = ref.watch(siswaControllerProvider);

    void updateList(String value) {
      try {
        if (value != '') {
          siswaResult.clear();
          var temp = siswas
              .where((element) =>
                  element.nama!.toLowerCase().contains(value.toLowerCase()) ||
                  element.nis!.toLowerCase().contains(value.toLowerCase()))
              .toList();
          temp.map((e) => siswaResult.add(e)).toList();
        } else {
          siswaResult.clear();
        }
      } catch (e) {
        Logger().e(e);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: HexColor('673ab7'),
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(18.0))),
            title: const Text(
              'Data Siswa',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TambahSiswa()));
                    },
                    icon: Icon(
                      EvaIcons.plusCircle,
                      color: HexColor('0F0D35'),
                      size: 35,
                    )),
              )
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  HexColor('673ab7'),
                  HexColor('00BCD4'),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 50.0, 18.0, 0),
                    child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: search,
                        onChanged: (value) {
                          updateList(value);
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          suffixIcon: search.text.isNotEmpty
                              ? IconButton(
                                  splashRadius: 20,
                                  onPressed: () {
                                    search.text = '';
                                    FocusScope.of(context).unfocus();
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ))
                              : null,
                          hintText: 'cari nama atau nis siswa ',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          prefixIcon: const Icon(
                            EvaIcons.search,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                      child: siswas.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.0))),
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/img/no_data.svg',
                                              width: 350,
                                            ),
                                            const Text('Tidak ada data!'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )))
                          : Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0))),
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: search.text.isNotEmpty
                                        ? siswaResult.length
                                        : siswas.length,
                                    itemBuilder: (ctx, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: ShowUp(
                                          delay: 150,
                                          child: isloading
                                              ? buildSkeleton(context)
                                              : Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0)),
                                                  elevation: 0.5,
                                                  color: HexColor('204FA1'),
                                                  child: InkWell(
                                                    onTap: () {
                                                      DetailBottomSheet(
                                                          siswa: siswas[index],
                                                          result: index,
                                                          context: context,
                                                          detailButton: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => DetailSiswa(
                                                                      siswa: search
                                                                              .text
                                                                              .isNotEmpty
                                                                          ? siswaResult[
                                                                              index]
                                                                          : siswas[
                                                                              index]),
                                                                ));
                                                          },
                                                          editButton: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => EditSiswa(
                                                                      siswa: search
                                                                              .text
                                                                              .isNotEmpty
                                                                          ? siswaResult[
                                                                              index]
                                                                          : siswas[
                                                                              index]),
                                                                ));
                                                          });
                                                    },
                                                    onLongPress: () {
                                                      DeleteBottomSheet(
                                                          context: context,
                                                          siswa: siswas[index],
                                                          result: index,
                                                          callback: () async {
                                                            try {
                                                              await ref.read(siswaControllerProvider.notifier).deleteSiswa(
                                                                  context:
                                                                      context,
                                                                  sid: search
                                                                          .text
                                                                          .isNotEmpty
                                                                      ? siswaResult[
                                                                              index]
                                                                          .sid
                                                                          .toString()
                                                                      : siswas[
                                                                              index]
                                                                          .sid
                                                                          .toString());
                                                              setState(() {});
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Snackbars()
                                                                  .successSnackbars(
                                                                      context,
                                                                      'Berhasil',
                                                                      'Berhasil Menghapus Data');
                                                              Navigator.of(
                                                                  context)
                                                                ..pop(context)
                                                                ..pop(ctx);
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const DataSiswa()));
                                                            } on FirebaseException catch (e) {
                                                              Snackbars()
                                                                  .failedSnackbars(
                                                                      context,
                                                                      'Gagal',
                                                                      e.message
                                                                          .toString());
                                                            }
                                                          });
                                                    },
                                                    child: ListTile(
                                                      title: Text(
                                                        search.text.isNotEmpty
                                                            ? siswaResult[index]
                                                                .nama
                                                                .toString()
                                                            : siswas[index]
                                                                .nama
                                                                .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        search.text.isNotEmpty
                                                            ? siswaResult[index]
                                                                .nis
                                                                .toString()
                                                            : siswas[index]
                                                                .nis
                                                                .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        search.text.isNotEmpty
                                                            ? siswaResult[index]
                                                                .kelas
                                                                .toString()
                                                            : siswas[index]
                                                                .kelas
                                                                .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ))
                ],
              )),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> DetailBottomSheet(
      {required BuildContext context,
      required dynamic editButton,
      required Siswa siswa,
      required dynamic result,
      required dynamic detailButton}) {
    return showMaterialModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        // ignore: sized_box_for_whitespace
        builder: (context) => Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                        child: Column(
                      children: [
                        Text(
                          search.text.isNotEmpty
                              ? siswaResult[result].nama.toString()
                              : siswa.nama.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          search.text.isNotEmpty
                              ? siswaResult[result].nis.toString()
                              : siswa.nis.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 30.0),
                    ElevatedButton.icon(
                        icon: const Icon(EvaIcons.editOutline),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: HexColor('204FA1')),
                        onPressed: editButton,
                        label: const Text(
                          'Ubah Data Siswa',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        )),
                    const SizedBox(height: 15.0),
                    ElevatedButton.icon(
                        icon: const Icon(EvaIcons.eye),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            side: BorderSide(color: HexColor('204FA1')),
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: Colors.white,
                            foregroundColor: HexColor('204FA1')),
                        onPressed: detailButton,
                        label: const Text(
                          'Lihat Detail Siswa',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        )),
                  ],
                ),
              ),
            ));
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> DeleteBottomSheet(
      {required BuildContext context,
      required VoidCallback callback,
      required dynamic result,
      required Siswa siswa}) {
    return showMaterialModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        // ignore: sized_box_for_whitespace
        builder: (context) => Container(
              height: 170,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 40.0),
                child: Column(
                  children: [
                    Text(
                      search.text.isNotEmpty
                          ? siswaResult[result].nama.toString()
                          : siswa.nama.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      search.text.isNotEmpty
                          ? siswaResult[result].nis.toString()
                          : siswa.nis.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: callback,
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text(
                            'Hapus',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.redAccent),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  Widget buildSkeleton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: InkWell(
          splashColor: Colors.grey[800],
          child: SkeletonContainer.square(
            width: MediaQuery.of(context).size.width * 1,
            height: 70,
          ),
        ),
      );
}
