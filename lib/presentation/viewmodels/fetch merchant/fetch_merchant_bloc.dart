import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/merchant_model.dart';
import 'package:pndb_admin/data/services/all_merchant_service.dart';

part 'fetch_merchant_event.dart';
part 'fetch_merchant_state.dart';

class FetchMerchantBloc extends Bloc<FetchMerchantEvent, FetchMerchantState> {
  final MerchantService merchantService;

  FetchMerchantBloc({required this.merchantService})
      : super(FetchMerchantInitial()) {
    on<LoadMerchants>(_onLoadMerchants);
    on<LoadMerchantDetails>(_onLoadMerchantDetails);
  }

  Future<void> _onLoadMerchants(
    LoadMerchants event,
    Emitter<FetchMerchantState> emit,
  ) async {
    emit(FetchMerchantLoading());
    try {
      final merchants = await merchantService.fetchMerchants(page: event.page);
      emit(FetchMerchantLoaded(merchants: merchants, currentPage: event.page));
    } catch (e) {
      emit(FetchMerchantError(e.toString()));
    }
  }

  Future<void> _onLoadMerchantDetails(
    LoadMerchantDetails event,
    Emitter<FetchMerchantState> emit,
  ) async {
    final currentState = state;

    if (currentState is FetchMerchantLoaded) {
      try {
        final merchant =
            await merchantService.fetchMerchantDetails(event.merchantId);
        emit(FetchMerchantLoaded(
          merchants: currentState.merchants,
          currentPage: currentState.currentPage,
          selectedMerchant: merchant,
        ));
      } catch (e) {
        emit(FetchMerchantError(e.toString()));
      }
    }
  }
}
