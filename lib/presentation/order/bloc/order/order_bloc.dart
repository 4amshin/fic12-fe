import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fic12_fe/data/data_resources/auth_local_data_source.dart';
import 'package:fic12_fe/presentation/home/models/order_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc()
      : super(const _Success(
          products: [],
          totalQuantity: 0,
          totalPrice: 0,
          paymentMethod: '',
          nominalBayar: 0,
          idKasir: 0,
          namaKasir: '',
        )) {
    on<_AddPaymentMethod>(_addPaymentMethod);
    on<_AddNominalBayar>(_addNominalBayar);
    on<_Started>(_started);
  }

  Future<void> _addPaymentMethod(
    _AddPaymentMethod event,
    Emitter<OrderState> emit,
  ) async {
    emit(const _Loading());
    final usersData = await AuthLocalDataSource().getAuthData();

    // Simpan perhitungan total quantity dan total price dalam variabel tersendiri
    final totalQuantity = event.orders.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );
    final totalPrice = event.orders.fold<int>(
      0,
      (total, item) => total + (item.quantity * item.product.price),
    );

    emit(_Success(
      products: event.orders,
      totalQuantity: totalQuantity,
      totalPrice: totalPrice,
      paymentMethod: event.paymentMethod,
      nominalBayar: 0,
      idKasir: usersData.id,
      namaKasir: usersData.name,
    ));
  }

  void _addNominalBayar(
    _AddNominalBayar event,
    Emitter<OrderState> emit,
  ) {
    var currentState = state as _Success;
    emit(const _Loading());
    log(currentState.toString());
    emit(_Success(
      products: currentState.products,
      totalQuantity: currentState.totalQuantity,
      totalPrice: currentState.totalPrice,
      paymentMethod: currentState.paymentMethod,
      nominalBayar: event.nominal,
      idKasir: currentState.idKasir,
      namaKasir: currentState.namaKasir,
    ));
  }

  void _started(
    _Started event,
    Emitter<OrderState> emit,
  ) {
    emit(const _Loading());
    emit(const _Success(
      products: [],
      totalQuantity: 0,
      totalPrice: 0,
      paymentMethod: '',
      nominalBayar: 0,
      idKasir: 0,
      namaKasir: '',
    ));
  }
}
