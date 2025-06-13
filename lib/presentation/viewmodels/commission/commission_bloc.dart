import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/commission_merchant_model.dart';
import 'package:pndb_admin/data/services/commission_service.dart';

part 'commission_event.dart';
part 'commission_state.dart';

class CommissionBloc extends Bloc<CommissionEvent, CommissionState> {
  CommissionBloc() : super(CommissionInitial()) {
    on<FetchMerchants>((event, emit) async {
      emit(CommissionLoading());
      try {
        final merchants = await CommissionService.fetchAllMerchants();
        emit(CommissionLoaded(merchants));
      } catch (e) {
        emit(CommissionError(e.toString()));
      }
    });
  }
}