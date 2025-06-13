part of 'assigned_qr_bloc.dart';

@immutable
sealed class AssignedQrState {}

final class AssignedQrInitial extends AssignedQrState {}

class AssignedQrLoading extends AssignedQrState {}

class AssignedQrLoaded extends AssignedQrState {
  final List<QrCodeModel> qrCodes;

  AssignedQrLoaded(this.qrCodes);
}

class AssignedQrError extends AssignedQrState {
  final String message;

  AssignedQrError(this.message);
}
