import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/services/all_merchant_service.dart';

part 'verify_merchant_event.dart';
part 'verify_merchant_state.dart';

class VerifyMerchantBloc extends Bloc<VerifyMerchantEvent, VerifyMerchantState> {
  final MerchantService _merchantService;

  VerifyMerchantBloc(this._merchantService) : super(VerifyMerchantInitial()) {
    on<StartMerchantVerification>((event, emit) async {
      emit(VerifyingMerchant());
      try {
        final isSuccess = await _merchantService.verifyMerchant(event.merchantId);
        if (isSuccess) {
          emit(MerchantVerified());
        } else {
          emit(MerchantVerificationFailed('Verification failed. Try again.'));
        }
      } catch (e) {
        emit(MerchantVerificationFailed(e.toString()));
      }
    });
  }
}
