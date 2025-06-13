part of 'user_cashback_bloc.dart';

@immutable
sealed class UserCashbackState {}

final class UserCashbackInitial extends UserCashbackState {}

class CashbackLoading extends UserCashbackState {}

class CashbackLoaded extends UserCashbackState {
  final List<UserCashbackModel> transactions;
  final bool hasMore;

  CashbackLoaded({required this.transactions, required this.hasMore});
}

class CashbackError extends UserCashbackState {
  final String message;

  CashbackError(this.message);
}