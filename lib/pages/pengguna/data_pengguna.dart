import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myspp_app/components/animations/showup.dart';
import 'package:myspp_app/controller/users_controller.dart';
import 'package:myspp_app/model/users.dart';
import 'package:myspp_app/pages/pengguna/tambah_pengguna.dart';

class DataPengguna extends ConsumerStatefulWidget {
  const DataPengguna({super.key});

  @override
  ConsumerState<DataPengguna> createState() => _DataPenggunaState();
}

class _DataPenggunaState extends ConsumerState<DataPengguna> {
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  List<Users> userResult = [];

  Future<void> getAllData() async {
    await ref.read(usersControllerProvider.notifier).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    var usersData = ref.watch(usersControllerProvider);

    void updateList(String value) {
      try {
        if (value != '') {
          userResult.clear();
          var temp = usersData
              .where((element) =>
                  element.nama!.toLowerCase().contains(value.toLowerCase()) ||
                  element.email!.toLowerCase().contains(value.toLowerCase()))
              .toList();
          temp.map((e) => userResult.add(e)).toList();
        } else {
          userResult.clear();
        }
      } catch (e) {
        Logger().e(e);
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: HexColor('673ab7'),
        appBar: AppBar(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(18.0))),
          title: const Text('Data Pengguna',
              style: TextStyle(fontWeight: FontWeight.bold)),
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
                            builder: (context) => const TambahPengguna()));
                  },
                  icon: Icon(
                    EvaIcons.plusCircle,
                    color: HexColor('0F0D35'),
                    size: 35,
                  )),
            )
          ],
          elevation: 0,
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
                      hintText: 'cari nama siswa atau email',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: Colors.white)),
                      prefixIcon: const Icon(
                        EvaIcons.search,
                        color: Colors.white,
                      ),
                    )),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                  child: usersData.isEmpty
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
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: ListView.builder(
                                padding: const EdgeInsets.only(top: 30.0),
                                physics: const BouncingScrollPhysics(),
                                itemCount: search.text.isNotEmpty
                                    ? userResult.length
                                    : usersData.length,
                                itemBuilder: (ctx, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: ShowUp(
                                      delay: 150,
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          elevation: 0.5,
                                          color: HexColor('204FA1'),
                                          child: InkWell(
                                            onLongPress: () {
                                              // DeleteBottomSheet(
                                              //   context: context,
                                              //   result: index,
                                              //   users: usersData[index],
                                              //   callback: () async {
                                              //     try {
                                              //       ref
                                              //           .read(
                                              //               usersControllerProvider
                                              //                   .notifier)
                                              //           .deleteUser(
                                              //               context: context,
                                              //               email: usersData[index]
                                              //                   .email
                                              //                   .toString(),
                                              //               password: )
                                              //           .toString();
                                              //       setState(() {});
                                              //       if (!mounted) return;
                                              //       Snackbars().successSnackbars(
                                              //           context,
                                              //           'Berhasil',
                                              //           'Berhasil Menghapus Data');
                                              //       Navigator.of(context)
                                              //         ..pop(context)
                                              //         ..pop(ctx);
                                              //       Navigator.pushReplacement(
                                              //           context,
                                              //           MaterialPageRoute(
                                              //               builder: (context) =>
                                              //                   const DataPengguna()));
                                              //     } on FirebaseException catch (e) {
                                              //       Snackbars().failedSnackbars(
                                              //           context,
                                              //           'Gagal',
                                              //           e.message.toString());
                                              //     }
                                              //   },
                                              // );
                                            },
                                            child: ListTile(
                                              title: Text(
                                                search.text.isNotEmpty
                                                    ? userResult[index]
                                                        .nama
                                                        .toString()
                                                    : usersData[index]
                                                        .nama
                                                        .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(
                                                search.text.isNotEmpty
                                                    ? userResult[index]
                                                        .email
                                                        .toString()
                                                    : usersData[index]
                                                        .email
                                                        .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              trailing: Text(
                                                search.text.isNotEmpty
                                                    ? userResult[index]
                                                        .level
                                                        .toString()
                                                    : usersData[index]
                                                        .level
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
              // ElevatedButton(
              //     onPressed: () {}, child: Text(userResult.toString()))
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> DeleteBottomSheet(
      {required BuildContext context,
      required VoidCallback callback,
      required dynamic result,
      required Users users}) {
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
                          ? userResult[result].nama.toString()
                          : users.nama.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      search.text.isNotEmpty
                          ? userResult[result].email.toString()
                          : users.email.toString(),
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
}
