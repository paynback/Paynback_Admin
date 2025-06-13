part of 'fetch_user_bloc.dart';

@immutable
sealed class FetchUserEvent {}

class FetchUser extends FetchUserEvent {
  final int page;
  FetchUser({this.page = 1});
}

class FetchUserFullDetails extends FetchUserEvent {
  final String uid;
  FetchUserFullDetails(this.uid);
}