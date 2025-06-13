part of 'downloaded_qr_bloc.dart';

@immutable
sealed class DownloadedQrState {}

final class DownloadedQrInitial extends DownloadedQrState {}

final class DownloadedQrLoading extends DownloadedQrState {}

final class DownloadedQrLoaded extends DownloadedQrState {
  final List<QrCodeModel> qrCodes;
  DownloadedQrLoaded(this.qrCodes);
}

final class DownloadedQrError extends DownloadedQrState {
  final String message;
  DownloadedQrError(this.message);
}