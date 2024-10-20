import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fic12_fe/data/data_resources/product_local_data_source.dart';
import 'package:fic12_fe/data/data_resources/product_remote_data_source.dart';
import 'package:fic12_fe/data/models/request/product_request_model.dart';
import 'package:fic12_fe/data/models/response/product_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDataSource dataSource;
  List<Product> products = [];

  ProductBloc(this.dataSource) : super(const _Initial()) {
    on<_GetProduct>(_getProduct);
    on<_GetLocal>(_getLocal);
    on<_GetByCategory>(_getByCategory);
    on<_AddProduct>(_addProduct);
    on<_SearchProduct>(_searchProduct);
    on<_FetchAllFromState>(_fetchAllFromState);
  }

  Future<void> _getProduct(
    _GetProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const _Loading());
    final result = await dataSource.getProducts();
    result.fold(
      (error) => emit(_Error(message: error)),
      (product) {
        products = product.data;
        emit(_Success(products: product.data));
      },
    );
  }

  Future<void> _getLocal(
    _GetLocal event,
    Emitter<ProductState> emit,
  ) async {
    emit(const _Loading());
    final localData = await ProductLocalDataSource.instance.getAllProduct();
    products = localData;
    emit(_Success(products: products));
  }

  Future<void> _getByCategory(
    _GetByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(const _Loading());
    final newProducts = event.category == 'all'
        ? products
        : products
            .where((element) => element.category == event.category)
            .toList();
    emit(_Success(products: newProducts));
  }

  Future<void> _addProduct(
    _AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const _Loading());

    final requestData = ProductRequestModel(
      name: event.product.name,
      price: event.product.price,
      stock: event.product.stock,
      category: event.product.category,
      image: event.image,
      isBestSeller: event.product.isBestSeller ? 1 : 0,
    );

    log("Sending Request: ${requestData.toMap()}");
    final response =
        await dataSource.addProduct(productRequestModel: requestData);
    log("Response Status Code : $response");
    response.fold(
      (error) => emit(_Error(message: error)),
      (success) {
        products.add(success.data);
        emit(_Success(products: products));
      },
    );
  }

  void _searchProduct(
    _SearchProduct event,
    Emitter<ProductState> emit,
  ) {
    emit(const _Loading());
    final newProducts = products
        .where((element) =>
            element.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(_Success(products: newProducts));
  }

  void _fetchAllFromState(
    _FetchAllFromState event,
    Emitter<ProductState> emit,
  ) {
    emit(const _Loading());
    emit(_Success(products: products));
  }
}
