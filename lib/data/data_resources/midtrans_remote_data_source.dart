import 'dart:convert';

import 'package:fic12_fe/data/data_resources/auth_local_data_source.dart';
import 'package:fic12_fe/data/models/response/qris_response_model.dart';
import 'package:fic12_fe/data/models/response/qris_status_response_model.dart';
import 'package:http/http.dart' as http;

class MidtransRemoteDataSource {
  String generateBasicAuthHeader(String serverKey) {
    final base64Credentials = base64Encode(utf8.encode('$serverKey:'));
    final authHeader = 'Basic $base64Credentials';

    return authHeader;
  }

  Future<QrisResponseModel> generateQRCode({
    required String orderId,
    required int grossAmount,
  }) async {
    final serverKey = await AuthLocalDataSource().getMidtransServerKey();
    // const serverKey = 'SB-Mid-server-F1B2xE-82Th76qSWECE-1jjw';

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(serverKey),
    };

    final body = jsonEncode({
      'payment_type': 'gopay',
      'transaction_details': {
        'order_id': orderId,
        'gross_amount': grossAmount,
      },
    });

    final response = await http.post(
      Uri.parse('https://api.sandbox.midtrans.com/v2/charge'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return QrisResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to generate QR Code');
    }
  }

  Future<QrisStatusResponseModel> checkPaymentStatus(
      {required String orderId}) async {
    final serverKey = await AuthLocalDataSource().getMidtransServerKey();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(serverKey),
    };

    final response = await http.get(
      Uri.parse('https://api.sandbox.midtrans.com/v2/$orderId/status'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return QrisStatusResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to check payment status');
    }
  }
}
