import 'package:flutter/material.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
import 'package:smart_snackbars/smart_snackbars.dart';

class Snackbars {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  successSnackbars(BuildContext context, String title, String message) {
    SmartSnackBars.showTemplatedSnackbar(
      elevation: 2,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      leading: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      duration: const Duration(milliseconds: 3500),
      animateFrom: AnimateFrom.fromBottom,
      backgroundColor: Colors.green,
      titleWidget: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      subTitleWidget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      context: context,
    );
  }

  failedSnackbars(BuildContext context, String title, String message) {
    SmartSnackBars.showTemplatedSnackbar(
      persist: true,
      elevation: 2,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      leading: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: const Icon(
          Icons.block,
          color: Colors.white,
        ),
      ),
      animateFrom: AnimateFrom.fromBottom,
      duration: const Duration(milliseconds: 3500),
      backgroundColor: Colors.red,
      titleWidget: Text(
        title,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700),
      ),
      subTitleWidget: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            message,
            maxLines: 5,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
      context: context,
    );
  }

  helpSnackbars(BuildContext context, String title, String message) {
    SmartSnackBars.showTemplatedSnackbar(
      elevation: 2,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      leading: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: const Icon(
          Icons.info_outline_sharp,
          color: Colors.white,
        ),
      ),
      animateFrom: AnimateFrom.fromBottom,
      duration: const Duration(milliseconds: 3500),
      backgroundColor: Colors.blue,
      titleWidget: Text(
        title,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700),
      ),
      subTitleWidget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      context: context,
    );
  }

  warningSnackbars(BuildContext context, String title, String message) {
    SmartSnackBars.showTemplatedSnackbar(
      elevation: 2,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      leading: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: const Icon(Icons.warning)),
      animateFrom: AnimateFrom.fromBottom,
      duration: const Duration(milliseconds: 3500),
      backgroundColor: Colors.yellow,
      titleWidget: Text(
        title,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700),
      ),
      subTitleWidget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      context: context,
    );
  }
}
