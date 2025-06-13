part of 'user_cashback_bloc.dart';

@immutable
sealed class UserCashbackEvent {}

class FetchCashback extends UserCashbackEvent {
  final String userId;
  final int page;
  final int limit;

  FetchCashback({required this.userId, required this.page, required this.limit});
}