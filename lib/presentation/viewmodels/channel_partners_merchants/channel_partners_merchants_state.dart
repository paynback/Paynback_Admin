part of 'channel_partners_merchants_bloc.dart';

@immutable
sealed class ChannelPartnersMerchantsState {}

final class ChannelPartnersMerchantsInitial extends ChannelPartnersMerchantsState {}

class ChannelPartnersMerchantsLoading extends ChannelPartnersMerchantsState {}

class ChannelPartnersMerchantsLoaded extends ChannelPartnersMerchantsState {
  final List<Merchant> merchants;
  ChannelPartnersMerchantsLoaded({required this.merchants});
}

class ChannelPartnersMerchantsError extends ChannelPartnersMerchantsState {
  final String message;
  ChannelPartnersMerchantsError({required this.message});
}