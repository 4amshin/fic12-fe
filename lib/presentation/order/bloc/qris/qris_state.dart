part of 'qris_bloc.dart';

@freezed
class QrisState with _$QrisState {
  const factory QrisState.initial() = _Initial;
  const factory QrisState.loading() = _Loading;
  const factory QrisState.qrisResponse({
    required QrisResponseModel qrisResponseModel,
  }) = _QrisResponse;
  const factory QrisState.success({required String message}) = _Success;
  const factory QrisState.error({required String message}) = _Error;
  const factory QrisState.statusCheck({
    required QrisStatusResponseModel qrisStatusResponseModel,
  }) = _StatusCheck;
}
