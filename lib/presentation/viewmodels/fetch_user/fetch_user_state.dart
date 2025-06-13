part of 'fetch_user_bloc.dart';

@immutable
sealed class FetchUserState {}

final class FetchUserInitial extends FetchUserState {}

class FetchUserLoading extends FetchUserState {}

class FetchUserLoaded extends FetchUserState {
  final List<UserModel> users;
  final bool hasMore;
  final int page;

  FetchUserLoaded({required this.users, required this.hasMore, required this.page});
}

class FetchUserError extends FetchUserState {
  final String message;
  FetchUserError({required this.message});
}