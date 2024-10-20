part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.started() = _Started;
  const factory OrderEvent.addPaymentMethod({
    required String paymentMethod,
    required List<OrderItem> orders,
  }) = _AddPaymentMethod;
  const factory OrderEvent.addNominalBayar({
    required int nominal,
  }) = _AddNominalBayar;
}
