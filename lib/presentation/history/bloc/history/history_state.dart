part of 'history_bloc.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = _Initial;
  const factory HistoryState.loading() = _Loading;
  const factory HistoryState.success({required List<OrderModel> histories}) =
      _Success;
  const factory HistoryState.error({required String message}) = _Error;
}
