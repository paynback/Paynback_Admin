part of 'user_transaction_bloc.dart';

@immutable
sealed class UserTransactionEvent {}

class FetchTransactions extends UserTransactionEvent {
  final String userId;
  final int page;
  final int limit;

  FetchTransactions({required this.userId, required this.page, required this.limit});
}