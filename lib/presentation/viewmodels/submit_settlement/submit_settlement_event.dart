part of 'submit_settlement_bloc.dart';

@immutable
sealed class SubmitSettlementEvent {}

class SubmitSettlement extends SubmitSettlementEvent {
  final String settlementId;
  final String status; // SETTLED or FAILED
  final String? utr;

  SubmitSettlement({
    required this.settlementId,
    required this.status,
    this.utr,
  });
}