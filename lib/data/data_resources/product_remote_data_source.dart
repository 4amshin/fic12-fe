import 'package:fic12_fe/core/constants/variables.dart';
import 'package:fic12_fe/data/data_resources/auth_local_data_source.dart';
import 'package:fic12_fe/data/models/request/product_request_model.dart';
import 'package:fic12_fe/data/models/response/add_product_response_model.dart';
import 'package:fic12_fe/data/models/response/product_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

class ProductRemoteDataSource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final loginToken = await AuthLocalDataSource().getToken();

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $loginToken',
    };

    const baseUrl = "${Variables.baseUrl}/api/productApi";

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return right(ProductResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed get List Product');
    }
  }

  Future<Either<String, AddProductResponseModel>> addProduct({
    required ProductRequestModel productRequestModel,
  }) async {
    final loginToken = await AuthLocalDataSource().getToken();

    var headers = {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $loginToken',
    };

    const baseUrl = "${Variables.baseUrl}/api/productApi";

    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields.addAll(productRequestModel.toMap());
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        productRequestModel.image.path,
      ),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final String body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return right(AddProductResponseModel.fromJson(body));
    } else {
      return left(body);
    }
  }
}
