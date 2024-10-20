part of 'checkout_bloc.dart';

@freezed
class CheckoutEvent with _$CheckoutEvent {
  const factory CheckoutEvent.started() = _Started;
  const factory CheckoutEvent.addCheckout({required Product product}) =
      _AddCheckout;
  const factory CheckoutEvent.removeCheckout({required Product product}) =
      _RemoveCheckout;
}
