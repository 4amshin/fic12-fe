import 'dart:developer';

import 'package:fic12_fe/data/models/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  Future<bool> saveAuthData(AuthResponseModel model) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final res = await pref.setString('auth', model.toJson());
    log('Login Token Saved');
    return res;
  }

  Future<String> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString('auth') ?? '';
    final authData = AuthResponseModel.fromJson(jsonString);
    return authData.jwtToken;
  }

  Future<bool> removeToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final res = await pref.remove('auth');
    log('Remove Login Token');
    return res;
  }

  Future<bool> isLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    return authJson.isNotEmpty;
  }

  Future<AuthResponseModel> getAuthData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString('auth') ?? '';
    final authData = AuthResponseModel.fromJson(jsonString);
    return authData;
  }

  Future<int> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    final authData = AuthResponseModel.fromJson(authJson);
    return authData.id;
  }

  Future<void> saveMidtransServerKey(String serverKey) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('server_key', serverKey);
    log('Midtrans Server Key ($serverKey) Saved');
  }

  Future<String> getMidtransServerKey() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final serverKey = pref.getString('server_key');
    log('Fetching Current Midtrans Server Key ($serverKey)');
    return serverKey ?? '';
  }
}
