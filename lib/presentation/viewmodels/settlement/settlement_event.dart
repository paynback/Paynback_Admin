part of 'settlement_bloc.dart';

@immutable
sealed class SettlementEvent {}

class FetchSettlements extends SettlementEvent {
  final String status;
  final int page;

  FetchSettlements({required this.status, this.page = 1});
}