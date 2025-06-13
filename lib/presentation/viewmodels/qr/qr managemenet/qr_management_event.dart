part of 'qr_management_bloc.dart';

@immutable
sealed class QrManagementEvent {}

class FetchGeneratedQrCodes extends QrManagementEvent {}

class GenerateQrs extends QrManagementEvent {
  final int count;
  GenerateQrs(this.count);
}
