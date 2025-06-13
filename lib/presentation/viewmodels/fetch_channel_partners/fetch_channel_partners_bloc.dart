import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/channel_partner_model.dart';
import 'package:pndb_admin/data/services/channel_partner_service.dart';

part 'fetch_channel_partners_event.dart';
part 'fetch_channel_partners_state.dart';

class FetchChannelPartnersBloc extends Bloc<FetchChannelPartnersEvent, FetchChannelPartnersState> {
  final ChannelPartnerService api;

  FetchChannelPartnersBloc({required this.api}) : super(FetchChannelPartnersInitial()) {
    on<FetchChannelPartnersEvent>((event, emit) async {
      if (event is FetchChannelPartnersRequested) {
        emit(FetchChannelPartnersLoading());
        try {
          final partners = await api.fetchChannelPartners();
          emit(FetchChannelPartnersSuccess(partners));
        } catch (e) {
          emit(FetchChannelPartnersFailure(e.toString()));
        }
      }
    });
  }
}