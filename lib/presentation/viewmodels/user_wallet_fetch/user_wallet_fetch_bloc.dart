import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/services/user_service.dart';

part 'user_wallet_fetch_event.dart';
part 'user_wallet_fetch_state.dart';

class UserWalletFetchBloc extends Bloc<UserWalletFetchEvent, UserWalletFetchState> {
  final UserService userService;
  UserWalletFetchBloc({required this.userService}) : super(UserWalletFetchInitial()) {
    on<FetchUserWallet>((event, emit) async {
      emit(UserWalletLoading());

      try {
        final wallet = await userService.fetchUserWallet(event.userId);
        emit(UserWalletLoaded(wallet));
      } catch (e) {
        emit(UserWalletError('Error: $e'));
      }
    });
  }
}
