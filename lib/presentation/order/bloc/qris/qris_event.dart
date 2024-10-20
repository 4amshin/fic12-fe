part of 'qris_bloc.dart';

@freezed
class QrisEvent with _$QrisEvent {
  const factory QrisEvent.started() = _Started;
  const factory QrisEvent.generateQRCode({
    required String orderId,
    required int grossAmount,
  }) = _GenerateQRCode;
  const factory QrisEvent.checkPaymentStatus({
    required String orderId,
  }) = _CheckPaymentStatus;
}
