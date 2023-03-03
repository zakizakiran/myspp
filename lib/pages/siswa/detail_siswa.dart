import 'dart:isolate';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/components/skeleton_container.dart';
import 'package:myspp_app/controller/siswa_controller.dart';
import 'package:myspp_app/model/siswa.dart';
import 'package:myspp_app/pages/siswa/edit_siswa.dart';

class DetailSiswa extends ConsumerStatefulWidget {
  final Siswa? siswa;
  const DetailSiswa({super.key, required this.siswa});

  @override
  ConsumerState<DetailSiswa> createState() => _DetailSiswaState();
}

class _DetailSiswaState extends ConsumerState<DetailSiswa> {
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSiswa(siswa: widget.siswa!),
                      ));
                },
                icon: const Icon(
                  EvaIcons.editOutline,
                  size: 30.0,
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
