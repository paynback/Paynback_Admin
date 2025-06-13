part of 'fetch_user_details_bloc.dart';

@immutable
sealed class FetchUserDetailsState {}

final class FetchUserDetailsInitial extends FetchUserDetailsState {}

class UserLoading extends FetchUserDetailsState {}

class UserLoaded extends FetchUserDetailsState {
  final UserModel user;
  UserLoaded(this.user);
}

class UserError extends FetchUserDetailsState {
  final String message;
  UserError(this.message);
}