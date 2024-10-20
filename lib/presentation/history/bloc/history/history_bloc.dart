import 'package:bloc/bloc.dart';
import 'package:fic12_fe/data/data_resources/product_local_data_source.dart';
import 'package:fic12_fe/presentation/order/models/order_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const _Initial()) {
    on<_FetchHistory>(_fetchHistory);
  }

  Future<void> _fetchHistory(
    _FetchHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const _Loading());
    final data = await ProductLocalDataSource.instance.getAllOrders();
    emit(_Success(histories: data));
  }
}
