part of 'submit_settlement_bloc.dart';

@immutable
sealed class SubmitSettlementState {}

final class SubmitSettlementInitial extends SubmitSettlementState {}

class SubmitSettlementLoading extends SubmitSettlementState {}

class SubmitSettlementSuccess extends SubmitSettlementState {}

class SubmitSettlementFailure extends SubmitSettlementState {}