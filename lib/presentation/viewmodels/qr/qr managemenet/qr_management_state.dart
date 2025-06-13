part of 'qr_management_bloc.dart';

@immutable
sealed class QrManagementState {}

final class QrManagementInitial extends QrManagementState {}

final class QrManagementLoading extends QrManagementState {}

final class QrManagementLoaded extends QrManagementState {
  final List<QrCodeModel> qrCodes;
  QrManagementLoaded(this.qrCodes);
}

final class QrManagementError extends QrManagementState {
  final String message;

  QrManagementError(this.message);
}
