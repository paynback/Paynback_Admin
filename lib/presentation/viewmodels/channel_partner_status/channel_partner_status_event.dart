part of 'channel_partner_status_bloc.dart';

@immutable
sealed class ChannelPartnerStatusEvent {}

class ToggleBlockStatus extends ChannelPartnerStatusEvent {
  final String id;
  final bool isBlocked;

  ToggleBlockStatus({required this.id, required this.isBlocked});
}