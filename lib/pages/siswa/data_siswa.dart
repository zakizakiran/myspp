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
          appBar: AppBar(
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
          body: SafeArea(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
            child: Column(
              children: [
                TextField(
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
                              ))
                          : null,
                      hintText: 'cari nama siswa atau nis',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: HexColor('204FA1'))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: HexColor('204FA1'))),
                      prefixIcon: Icon(
                        EvaIcons.search,
                        color: HexColor('204FA1'),
                      ),
                    )),
                const SizedBox(height: 20.0),
                Expanded(
                    child: siswas.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/img/no_data.svg',
                                width: 300,
                              ),
                              const Text('Tidak ada data!'),
                            ],
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: search.text.isNotEmpty
                                ? siswaResult.length
                                : siswas.length,
                            itemBuilder: (ctx, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: ShowUp(
                                  delay: 150,
                                  child: isloading
                                      ? buildSkeleton(context)
                                      : Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          elevation: 0.5,
                                          color: HexColor('204FA1'),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailSiswa(
                                                            siswa: search.text
                                                                    .isNotEmpty
                                                                ? siswaResult[
                                                                    index]
                                                                : siswas[
                                                                    index]),
                                                  ));
                                            },
                                            onLongPress: () {
                                              DeleteBottomSheet(context,
                                                  () async {
                                                try {
                                                  await ref
                                                      .read(siswaControllerProvider
                                                          .notifier)
                                                      .deleteSiswa(
                                                          context: context,
                                                          sid: search.text
                                                                  .isNotEmpty
                                                              ? siswaResult[
                                                                      index]
                                                                  .sid
                                                                  .toString()
                                                              : siswas[index]
                                                                  .sid
                                                                  .toString());
                                                  setState(() {});
                                                  if (!mounted) return;
                                                  Snackbars().successSnackbars(
                                                      context,
                                                      'Berhasil',
                                                      'Berhasil Menghapus Data');
                                                  Navigator.of(context)
                                                    ..pop(context)
                                                    ..pop(ctx);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const DataSiswa()));
                                                } on FirebaseException catch (e) {
                                                  Snackbars().failedSnackbars(
                                                      context,
                                                      'Gagal',
                                                      e.message.toString());
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
                                                  fontWeight: FontWeight.bold,
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
                          ))
                // ElevatedButton(
                //     onPressed: () {}, child: Text(siswaResult.toString()))
              ],
            ),
          )),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> DeleteBottomSheet(
      BuildContext context, VoidCallback callback) {
    return showMaterialModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        // ignore: sized_box_for_whitespace
        builder: (context) => Container(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 40.0),
                child: Column(
                  children: [
                    const Text(
                      'Apakah anda yakin untuk menghapus?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15.0),
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
