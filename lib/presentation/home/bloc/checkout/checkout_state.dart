part of 'checkout_bloc.dart';

@freezed
class CheckoutState with _$CheckoutState {
  const factory CheckoutState.initial() = _Initial;
  const factory CheckoutState.loading() = _Loading;
  const factory CheckoutState.success({
    required List<OrderItem> products,
    required int totalQuantity,
    required int totalPrice,
  }) = _Success;
  const factory CheckoutState.error({
    required String message,
  }) = _Error;
}
