import 'package:shared_preferences/shared_preferences.dart';

// Fungsi ini akan disebutkan ketika pengguna masuk
Future<void> createSession(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}

// Fungsi ini akan disebutkan ketika pengguna keluar
Future<void> deleteSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
}

// Fungsi ini akan dipanggil ketika aplikasi dimulai kembali
Future<String?> getSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}
