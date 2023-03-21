import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/components/skeleton_container.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/controller/siswa_controller.dart';
import 'package:myspp_app/model/siswa.dart';
import 'package:myspp_app/pages/pengguna/tambah_pengguna_siswa.dart';
import 'package:myspp_app/pages/siswa/data_siswa.dart';

class DetailSiswa extends ConsumerStatefulWidget {
  final Siswa? siswa;
  const DetailSiswa({super.key, required this.siswa});

  @override
  ConsumerState<DetailSiswa> createState() => _DetailSiswaState();
}

class _DetailSiswaState extends ConsumerState<DetailSiswa> {
  bool isloading = true;
  int count = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Siswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          actionsPadding: const EdgeInsets.all(20.0),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          title: const Text(
                            'Apakah anda yakin untuk menghapusnya?',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await ref
                                      .read(siswaControllerProvider.notifier)
                                      .deleteSiswa(
                                          context: context,
                                          sid: widget.siswa!.sid.toString());
                                  setState(() {});
                                  if (!mounted) return;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 4);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const DataSiswa(),
                                      ));
                                  Snackbars().successSnackbars(context,
                                      'Berhasil', 'Berhasil Menghapus Data');
                                } on FirebaseException catch (e) {
                                  Snackbars().failedSnackbars(
                                      context, 'Gagal', e.message.toString());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  side:
                                      const BorderSide(color: Colors.redAccent),
                                  padding: const EdgeInsets.all(15.0),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0))),
                              child: const Text('Hapus'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: const EdgeInsets.all(15.0),
                                  backgroundColor: HexColor('204FA1'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0))),
                              child: const Text('Tidak'),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(
                  EvaIcons.trash2Outline,
                  size: 25.0,
                  color: Colors.redAccent,
                )),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/img/detailSiswa.svg',
                  width: 300,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: isloading
                    ? buildSkeleton(context)
                    : Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        color: HexColor('204FA1'),
                        margin: const EdgeInsets.all(20.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'NISN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white),
                              ),
                              Text(
                                widget.siswa!.nisn.toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'NIS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white),
                              ),
                              Text(
                                widget.siswa!.nis.toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Nama',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.siswa!.nama.toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Jurusan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.siswa!.jurusan.toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Kelas',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.siswa!.kelas.toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Telepon',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.siswa!.telp.toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Alamat',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.siswa!.alamat.toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15.0),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(color: HexColor('204FA1')),
                            )),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TambahPenggunaSiswa(
                                  siswa: widget.siswa,
                                ),
                              ));
                        },
                        child: Text(
                          'Buat Akun',
                          style: TextStyle(
                              color: HexColor('204FA1'),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        )),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSkeleton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: InkWell(
            splashColor: Colors.grey[800],
            child: SkeletonContainer.square(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.45,
            ),
          ),
        ),
      );
}
