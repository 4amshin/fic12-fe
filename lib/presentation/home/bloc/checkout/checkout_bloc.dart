import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fic12_fe/data/models/response/product_response_model.dart';
import 'package:fic12_fe/presentation/home/models/order_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_bloc.freezed.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc()
      : super(const _Success(
          products: [],
          totalQuantity: 0,
          totalPrice: 0,
        )) {
    on<_Started>(_clearCheckout);
    on<_AddCheckout>(_addCheckout);
    on<_RemoveCheckout>(_removeCheckout);
  }

  void _clearCheckout(
    _Started event,
    Emitter<CheckoutState> emit,
  ) {
    emit(const _Loading());
    emit(const _Success(products: [], totalQuantity: 0, totalPrice: 0));
  }

  void _addCheckout(
    _AddCheckout event,
    Emitter<CheckoutState> emit,
  ) {
    final currentState = state as _Success;
    final newCheckout = List.of(currentState.products);

    _updateProductQuantity(newCheckout, event.product);

    emit(_createSuccessState(newCheckout));
  }

  void _removeCheckout(
    _RemoveCheckout event,
    Emitter<CheckoutState> emit,
  ) {
    final currentState = state as _Success;
    final newCheckout = List.of(currentState.products);

    _decreaseProductQuantity(newCheckout, event.product);

    emit(_createSuccessState(newCheckout));
  }

  CheckoutState _createSuccessState(List<OrderItem> products) {
    final totalQuantity = _calculateTotalQuantity(products);
    final totalPrice = _calculateTotalPrice(products);
    return _Success(
      products: products,
      totalQuantity: totalQuantity,
      totalPrice: totalPrice,
    );
  }

  void _updateProductQuantity(List<OrderItem> products, Product product) {
    final index = products.indexWhere((item) => item.product == product);
    if (index != -1) {
      log('Add Product Quantity');
      products[index].quantity++;
    } else {
      log('Adding Product to Order List');
      products.add(OrderItem(product: product, quantity: 1));
    }
  }

  void _decreaseProductQuantity(List<OrderItem> products, Product product) {
    final index = products.indexWhere((item) => item.product == product);
    if (index != -1) {
      if (products[index].quantity > 1) {
        log('Reduce Product Quantity');
        products[index].quantity--;
      } else {
        log('Removing Product From Order List');
        products.removeAt(index);
      }
    }
  }

  int _calculateTotalQuantity(List<OrderItem> products) {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }

  int _calculateTotalPrice(List<OrderItem> products) {
    return products.fold(
        0, (sum, item) => sum + (item.quantity * item.product.price));
  }
}
