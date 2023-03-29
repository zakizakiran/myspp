import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myspp_app/components/animations/showup.dart';
import 'package:myspp_app/components/skeleton_container.dart';
import 'package:myspp_app/controller/siswa_controller.dart';
import 'package:myspp_app/model/siswa.dart';
import 'package:myspp_app/pages/pengguna/tambah_pengguna_petugas.dart';

class DataSiswaPetugas extends ConsumerStatefulWidget {
  const DataSiswaPetugas({super.key});

  @override
  ConsumerState<DataSiswaPetugas> createState() => _DataSiswaPetugasState();
}

class _DataSiswaPetugasState extends ConsumerState<DataSiswaPetugas> {
  TextEditingController search = TextEditingController();
  bool isloading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  List<Siswa> siswaResult = [];

  Future<void> getAllSiswa() async {
    await ref.read(siswaControllerProvider.notifier).getSiswa();
  }

  Future loadData() async {
    setState(() {
      isloading = true;
      getAllSiswa();
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        child: Text(
                                            'Total Siswa | ${siswas.length}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[600])),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          padding:
                                              const EdgeInsets.only(top: 30.0),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: search.text.isNotEmpty
                                              ? siswaResult.length
                                              : siswas.length,
                                          itemBuilder: (ctx, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
                                              child: ShowUp(
                                                delay: 150,
                                                child: isloading
                                                    ? buildSkeleton(context)
                                                    : Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0)),
                                                        elevation: 0.5,
                                                        color:
                                                            HexColor('204FA1'),
                                                        child: InkWell(
                                                          onTap: () {
                                                            DetailBottomSheet(
                                                                siswa: siswas[
                                                                    index],
                                                                result: index,
                                                                context:
                                                                    context,
                                                                buatAkunButton:
                                                                    () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                TambahPenggunaPetugas(
                                                                          siswa:
                                                                              siswas[index],
                                                                        ),
                                                                      ));
                                                                });
                                                          },
                                                          child: ListTile(
                                                            title: Text(
                                                              search.text
                                                                      .isNotEmpty
                                                                  ? siswaResult[
                                                                          index]
                                                                      .nama
                                                                      .toString()
                                                                  : siswas[
                                                                          index]
                                                                      .nama
                                                                      .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            subtitle: Text(
                                                              search.text
                                                                      .isNotEmpty
                                                                  ? siswaResult[
                                                                          index]
                                                                      .nis
                                                                      .toString()
                                                                  : siswas[
                                                                          index]
                                                                      .nis
                                                                      .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            trailing: Text(
                                                              search.text
                                                                      .isNotEmpty
                                                                  ? siswaResult[
                                                                          index]
                                                                      .kelas
                                                                      .toString()
                                                                  : siswas[
                                                                          index]
                                                                      .kelas
                                                                      .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
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
      required Siswa siswa,
      required dynamic result,
      required dynamic buatAkunButton}) {
    return showMaterialModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        // ignore: sized_box_for_whitespace
        builder: (context) => Container(
              height: 200,
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
                        icon: const Icon(EvaIcons.plusCircleOutline),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            side: BorderSide(color: HexColor('204FA1')),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: Colors.white,
                            foregroundColor: HexColor('204FA1')),
                        onPressed: buatAkunButton,
                        label: const Text(
                          'Buat Akun Siswa',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        )),
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
