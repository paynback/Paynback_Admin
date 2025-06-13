part of 'settlement_bloc.dart';

@immutable
sealed class SettlementState {}

final class SettlementInitial extends SettlementState {}

class SettlementLoading extends SettlementState {}

class SettlementLoaded extends SettlementState {
  final List<SettlementModel> settlements;
  final bool hasMore;
  final int currentPage;
  final String status;

  SettlementLoaded({
    required this.settlements,
    required this.hasMore,
    required this.currentPage,
    required this.status,
  });

  SettlementLoaded copyWith({
    List<SettlementModel>? settlements,
    bool? hasMore,
    int? currentPage,
    String? status,
  }) {
    return SettlementLoaded(
      settlements: settlements ?? this.settlements,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
    );
  }
}

class SettlementError extends SettlementState {
  final String message;
  SettlementError(this.message);
}