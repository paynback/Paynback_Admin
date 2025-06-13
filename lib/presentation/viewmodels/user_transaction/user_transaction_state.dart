part of 'user_transaction_bloc.dart';

@immutable
sealed class UserTransactionState {}

final class UserTransactionInitial extends UserTransactionState {}

class TransactionLoading extends UserTransactionState {}

class TransactionLoaded extends UserTransactionState {
  final List<UserTransactionModel> transactions;
  final bool hasMore;

  TransactionLoaded({required this.transactions, required this.hasMore});
}

class TransactionError extends UserTransactionState {
  final String message;

  TransactionError(this.message);
}