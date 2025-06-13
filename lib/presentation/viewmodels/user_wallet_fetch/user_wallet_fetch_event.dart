part of 'user_wallet_fetch_bloc.dart';

@immutable
sealed class UserWalletFetchEvent {}

class FetchUserWallet extends UserWalletFetchEvent {
  final String userId;
  FetchUserWallet(this.userId);
}