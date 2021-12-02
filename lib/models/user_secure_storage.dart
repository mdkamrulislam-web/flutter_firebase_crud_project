import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyUserEmail = 'email';
  static Future setUserEmail(String userEmail) async {
    var a = await _storage.write(key: _keyUserEmail, value: userEmail);
    // ignore: avoid_print
    print('HELLO');
    // ignore: avoid_print
    print("Secured Email: $userEmail");
    // ignore: avoid_print
    print('HELLO');
    return a;
  }

  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }
}
