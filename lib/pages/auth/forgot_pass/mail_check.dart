import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/pages/auth/forgot_pass/forget_password.dart';
import 'package:myspp_app/pages/auth/login.dart';
import 'package:open_mail_app/open_mail_app.dart';

class MailCheck extends StatefulWidget {
  const MailCheck({super.key});

  @override
  State<MailCheck> createState() => MailCheckState();
}

class MailCheckState extends State<MailCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/img/mail_sent.svg',
                    width: 250,
                  ),
                  const Text(
                    'Periksa pesan email',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Kami sudah mengirimkan instruksi untuk mengganti kata sandi anda',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      var result = await OpenMailApp.openMailApp(
                          nativePickerTitle: 'Pilih aplikasi untuk lihat');
                      if (!result.didOpen && !result.canOpen) {
                        // ignore: use_build_context_synchronously
                        showNoMailAppsDialog(context);

                        // iOS: if multiple mail apps found, show dialog to select.
                        // There is no native intent/default app system in iOS so
                        // you have to do it yourself.
                      } else if (!result.didOpen && result.canOpen) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return MailAppPickerDialog(
                              mailApps: result.options,
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(18.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        backgroundColor: HexColor('204FA1')),
                    child: const Text(
                      'Buka aplikasi email',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: const Text(
                        'Lewati nanti',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black45,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  children: [
                    const Text(
                      'Tidak menerima email? Periksa pesan spam anda atau',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPassword(),
                          )),
                      child: Text(
                        'coba email lain',
                        style: TextStyle(
                            fontSize: 12.0, color: HexColor('204FA1')),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Mail App"),
          content: const Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
