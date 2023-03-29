import 'package:flutter/cupertino.dart';
import 'package:myspp_app/pages/home/user_home.dart';
import '../../pages/home/user_settings.dart';

List<Widget> screens() {
  return [
    const UserHome(),
    const UserSettings(),
  ];
}
