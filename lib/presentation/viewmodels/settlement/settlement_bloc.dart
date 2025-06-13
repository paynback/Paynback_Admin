import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/settlement_model.dart';
import 'package:pndb_admin/data/services/merchent_settlement.dart';

part 'settlement_event.dart';
part 'settlement_state.dart';

class SettlementBloc extends Bloc<SettlementEvent, SettlementState> {
  final MerchantSettlement repository;

  SettlementBloc(this.repository) : super(SettlementLoading()) {
    on<FetchSettlements>((event, emit) async {
      try {
        if (event.page == 1) emit(SettlementLoading());

        final result = await repository.fetchSettlements(
          page: event.page,
          limit: 10,
          date: DateTime.now(),
          status: event.status,
        );

        if (state is SettlementLoaded && event.page != 1) {
          final currentState = state as SettlementLoaded;
          emit(
            currentState.copyWith(
              settlements: [...currentState.settlements, ...result['settlements']],
              hasMore: result['hasMore'],
              currentPage: event.page,
            ),
          );
        } else {
          emit(SettlementLoaded(
            settlements: result['settlements'],
            hasMore: result['hasMore'],
            currentPage: event.page,
            status: event.status,
          ));
        }
      } catch (e) {
        emit(SettlementError(e.toString()));
      }
    });
  }
}