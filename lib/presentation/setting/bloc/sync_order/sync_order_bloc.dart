import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fic12_fe/data/data_resources/order_remote_data_source.dart';
import 'package:fic12_fe/data/data_resources/product_local_data_source.dart';
import 'package:fic12_fe/data/models/request/order_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_order_event.dart';
part 'sync_order_state.dart';
part 'sync_order_bloc.freezed.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDataSource orderRemoteDataSource;
  SyncOrderBloc(this.orderRemoteDataSource) : super(const _Initial()) {
    on<_SendOrder>(_sendOrder);
  }

  Future<void> _sendOrder(
    _SendOrder event,
    Emitter<SyncOrderState> emit,
  ) async {
    emit(const _Loading());

    final orderIsSyncZero =
        await ProductLocalDataSource.instance.getOrderByIsSync();

    for (final order in orderIsSyncZero) {
      final orderItems = await ProductLocalDataSource.instance
          .getOrderItemByOrderIdLocal(order.id!);

      final orderRequest = OrderRequestModel(
        transactionTime: order.transactionTime,
        totalPrice: order.totalPrice,
        totalItem: order.totalQuantity,
        kasirId: order.idKasir,
        paymentMethod: order.paymentMethod,
        orderItems: orderItems,
      );

      log(orderRequest.toString());

      final response = await orderRemoteDataSource.sendOrder(orderRequest);
      if (response) {
        await ProductLocalDataSource.instance.updateIsSyncOrderById(order.id!);
      }
    }

    emit(const _Success());
  }
}
