part of 'downloaded_qr_bloc.dart';

@immutable
sealed class DownloadedQrEvent {}

class FetchDownloadedQrs extends DownloadedQrEvent {}

class GenerateDownloadedQrs extends DownloadedQrEvent {
  final int limit;
  GenerateDownloadedQrs(this.limit);
}