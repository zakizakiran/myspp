import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/controller/auth_controller.dart';

class ForgetPassword extends ConsumerStatefulWidget {
  const ForgetPassword({super.key});

  @override
  ConsumerState<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends ConsumerState<ForgetPassword> {
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List className = [];

  void getData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('classgrade').get();
    Iterable data =
        snapshot.docs.map((e) => e.data().values.first).toList().cast<List>();
    data.map((e) => e.map((e2) => className.add(e2)).toList()).toList();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const Text(
                      'Kembali',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lupa Kata Sandi',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                      'Masukan email yang sudah terhubung dengan akun anda dan kami akan mengirimkan pesan untuk mengubah kata sandi anda'),
                  const SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        return null;
                      }),
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          prefixIcon: const Icon(Icons.alternate_email_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(authControllerProvider.notifier)
                      .forgetPass(context, email.text);
                  setState(() {});
                  if (!mounted) return;
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('204FA1'),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0))),
                child: const Text(
                  'Kirim',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              )
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
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 18, color: Colors.black87),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: HexColor('EAEBE7'),
                        )),
                    width: 150,
                    child: const Text(
                        'Perhatikan kembali jika anda ingin mengganti kata sandi',
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
