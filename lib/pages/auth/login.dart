import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/pages/onboard.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool passenable = true; //track password value
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Onboard()))),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/img/login.svg'),
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Mohon masukan email dengan benar';
                                }
                                return null;
                              }),
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                icon: Icon(Icons.alternate_email_rounded),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 18.0),
                            TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                return null;
                              }),
                              controller: password,
                              obscureText: passenable,
                              decoration: InputDecoration(
                                  labelText: 'Kata Sandi',
                                  labelStyle: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                  icon: const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (passenable) {
                                          passenable = false;
                                        } else {
                                          passenable = true;
                                        }
                                      });
                                    },
                                    icon: Icon(passenable == true
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Lupa kata sandi?',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await ref
                                    .read(authControllerProvider.notifier)
                                    .emailPassSignIn(
                                        context, email.text, password.text);
                                setState(() {});
                                if (!mounted) return;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor('204FA1'),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0))),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
