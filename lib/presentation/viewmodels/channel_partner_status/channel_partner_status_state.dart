part of 'channel_partner_status_bloc.dart';

@immutable
sealed class ChannelPartnerStatusState {}

final class ChannelPartnerStatusInitial extends ChannelPartnerStatusState {}

class ChannelPartnerStatusLoading extends ChannelPartnerStatusState {}

class ChannelPartnerStatusSuccess extends ChannelPartnerStatusState {
  final bool isBlocked;
  ChannelPartnerStatusSuccess({required this.isBlocked});
}

class ChannelPartnerStatusFailure extends ChannelPartnerStatusState {
  final String message;
  ChannelPartnerStatusFailure({required this.message});
}