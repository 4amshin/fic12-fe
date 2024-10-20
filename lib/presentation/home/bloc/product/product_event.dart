part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.started() = _Started;
  const factory ProductEvent.getProduct() = _GetProduct;
  const factory ProductEvent.getByCategory({
    required String category,
  }) = _GetByCategory;
  const factory ProductEvent.getLocal() = _GetLocal;
  const factory ProductEvent.addProduct({
    required Product product,
    required XFile image,
  }) = _AddProduct;
  const factory ProductEvent.searchProduct({required String query}) =
      _SearchProduct;
  const factory ProductEvent.fetchAllFromState() = _FetchAllFromState;
}
