part of 'user_wallet_fetch_bloc.dart';

@immutable
sealed class UserWalletFetchState {}

final class UserWalletFetchInitial extends UserWalletFetchState {}

class UserWalletLoading extends UserWalletFetchState {}

class UserWalletLoaded extends UserWalletFetchState {
  final double wallet;
  UserWalletLoaded(this.wallet);
}

class UserWalletError extends UserWalletFetchState {
  final String message;
  UserWalletError(this.message);
}