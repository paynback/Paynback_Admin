part of 'fetch_user_details_bloc.dart';

@immutable
sealed class FetchUserDetailsEvent {}

class GetUserDetailsEvent extends FetchUserDetailsEvent {
  final String uid;
  GetUserDetailsEvent(this.uid);
}

class BlockOrUnblockUserEvent extends FetchUserDetailsEvent {
  final String userId;
  final bool shouldBlock;

  BlockOrUnblockUserEvent({required this.userId, required this.shouldBlock});
}