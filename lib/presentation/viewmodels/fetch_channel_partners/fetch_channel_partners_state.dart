part of 'fetch_channel_partners_bloc.dart';

@immutable
sealed class FetchChannelPartnersState {}

final class FetchChannelPartnersInitial extends FetchChannelPartnersState {}

class FetchChannelPartnersLoading extends FetchChannelPartnersState {}

class FetchChannelPartnersSuccess extends FetchChannelPartnersState {
  final List<ChannelPartnerModel> partners;

  FetchChannelPartnersSuccess(this.partners);
}

class FetchChannelPartnersFailure extends FetchChannelPartnersState {
  final String error;

  FetchChannelPartnersFailure(this.error);
}