import 'package:flutter/material.dart';

class DataPengguna extends StatefulWidget {
  const DataPengguna({super.key});

  @override
  State<DataPengguna> createState() => _DataPenggunaState();
}

class _DataPenggunaState extends State<DataPengguna> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}
