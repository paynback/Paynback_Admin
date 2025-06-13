import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/services/commission_service.dart';

part 'update_all_commission_event.dart';
part 'update_all_commission_state.dart';

class UpdateAllCommissionBloc extends Bloc<UpdateAllCommissionEvent, UpdateAllCommissionState> {
  UpdateAllCommissionBloc() : super(UpdateAllCommissionInitial()) {
    on<UpdateCommissionRate>((event, emit) async {
      emit(UpdateLoading());
      try {
        await CommissionService.updateAllMerchantsCommission(event.rate);
        emit(UpdateSuccess());
      } catch (e) {
        emit(UpdateFailure(e.toString()));
      }
    });
  }
}