import 'dart:developer';

import 'package:fic12_fe/core/constants/variables.dart';
import 'package:fic12_fe/data/data_resources/auth_local_data_source.dart';
import 'package:fic12_fe/data/models/request/order_request_model.dart';
import 'package:http/http.dart' as http;

class OrderRemoteDataSource {
  Future<bool> sendOrder(OrderRequestModel requestModel) async {
    final url = Uri.parse('${Variables.baseUrl}/api/orderApi');
    final jwtToken = await AuthLocalDataSource().getToken();

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log('Request Model To API: ${requestModel.toMap()}');

    final response = await http.post(
      url,
      headers: headers,
      body: requestModel.toJson(),
    );

    if (response.statusCode == 201) {
      log('Success: ${response.body}');
      return true;
    } else {
      log('Fail : ${response.body}');
      return false;
    }
  }
}
