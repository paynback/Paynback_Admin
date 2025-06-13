part of 'fetch_channel_partners_bloc.dart';

@immutable
sealed class FetchChannelPartnersEvent {}

class FetchChannelPartnersRequested extends FetchChannelPartnersEvent {}