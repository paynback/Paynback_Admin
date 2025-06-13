import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/services/channel_partner_service.dart';

part 'channel_partner_status_event.dart';
part 'channel_partner_status_state.dart';

class ChannelPartnerStatusBloc extends Bloc<ChannelPartnerStatusEvent, ChannelPartnerStatusState> {
  ChannelPartnerStatusBloc() : super(ChannelPartnerStatusInitial()) {
    on<ToggleBlockStatus>((event, emit) async {
      emit(ChannelPartnerStatusLoading());
      final success = await ChannelPartnerService().toggleBlockStatus(
        event.id,
        event.isBlocked,
      );
      if (success) {
        emit(ChannelPartnerStatusSuccess(isBlocked: event.isBlocked));
      } else {
        emit(ChannelPartnerStatusFailure(message: 'Failed to update status'));
      }
    });
  }
}
