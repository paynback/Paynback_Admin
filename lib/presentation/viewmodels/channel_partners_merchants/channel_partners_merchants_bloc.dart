import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/merchant_model.dart';
import 'package:pndb_admin/data/services/channel_partner_service.dart';

part 'channel_partners_merchants_event.dart';
part 'channel_partners_merchants_state.dart';

class ChannelPartnersMerchantsBloc extends Bloc<ChannelPartnersMerchantsEvent, ChannelPartnersMerchantsState> {
  ChannelPartnersMerchantsBloc() : super(ChannelPartnersMerchantsInitial()) {
    on<LoadChannelPartnerMerchants>((event, emit) async {
      emit(ChannelPartnersMerchantsLoading());
      try {
        final merchants = await ChannelPartnerService().fetchMerchants(event.partnerId);
        emit(ChannelPartnersMerchantsLoaded(merchants: merchants));
      } catch (e) {
        emit(ChannelPartnersMerchantsError(message: e.toString()));
      }
    });
  }
}