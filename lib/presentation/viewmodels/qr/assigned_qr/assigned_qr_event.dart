part of 'assigned_qr_bloc.dart';

@immutable
sealed class AssignedQrEvent {}

class FetchAssignedQrCodes extends AssignedQrEvent {}

