import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/services/merchent_settlement.dart';

part 'submit_settlement_event.dart';
part 'submit_settlement_state.dart';

class SubmitSettlementBloc extends Bloc<SubmitSettlementEvent, SubmitSettlementState> {
  SubmitSettlementBloc() : super(SubmitSettlementInitial()) {
    on<SubmitSettlement>((event, emit) async {
      emit(SubmitSettlementLoading());
      final result = await MerchantSettlement().setSettlementStatus(
        settlementId: event.settlementId,
        status: event.status,
        utr: event.utr ?? '',
        
      );

      if (result) {
        emit(SubmitSettlementSuccess());
      } else {
        emit(SubmitSettlementFailure());
      }
    });
  }
}
