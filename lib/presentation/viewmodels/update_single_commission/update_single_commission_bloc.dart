import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/services/commission_service.dart';

part 'update_single_commission_event.dart';
part 'update_single_commission_state.dart';

class UpdateSingleCommissionBloc extends Bloc<UpdateSingleCommissionEvent, UpdateSingleCommissionState> {
  UpdateSingleCommissionBloc() : super(UpdateSingleCommissionInitial()) {
    on<UpdateSingleCommissionRate>((event, emit) async {
      emit(UpdateSingleCommissionLoading());
      try {
        await CommissionService.updateSingleMerchantsCommission(event.rate,event.merchantId);
        emit(UpdateSingleCommissionSuccess());
      } catch (e) {
        emit(UpdateSingleCommissionFailure(e.toString()));
      }
    });
  }
}
