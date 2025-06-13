part of 'channel_partners_merchants_bloc.dart';

@immutable
sealed class ChannelPartnersMerchantsEvent {}

class LoadChannelPartnerMerchants extends ChannelPartnersMerchantsEvent {
  final String partnerId;
  LoadChannelPartnerMerchants({required this.partnerId});
}