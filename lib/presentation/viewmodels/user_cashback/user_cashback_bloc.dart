import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/user_cashback_model.dart';
import 'package:pndb_admin/data/services/user_service.dart';

part 'user_cashback_event.dart';
part 'user_cashback_state.dart';

class UserCashbackBloc extends Bloc<UserCashbackEvent, UserCashbackState> {

  final UserService userService;

  final List<UserCashbackModel> _allTransactions = [];
  int _page = 1;
  final int _limit = 20;
  bool _hasMore = true;

  UserCashbackBloc({required this.userService}) : super(UserCashbackInitial()) {
    on<FetchCashback>((event, emit) async {
      if (!_hasMore && event.page != 1) return;

      if (event.page == 1) {
        emit(CashbackLoading());
        _allTransactions.clear();
        _hasMore = true;
      }

      try {
        final newTransactions = await userService.fetchCashbacks(
          userId: event.userId,
          page: event.page,
          limit: event.limit,
        );

        _hasMore = newTransactions.length == _limit;
        _allTransactions.addAll(newTransactions);

        emit(CashbackLoaded(transactions: _allTransactions, hasMore: _hasMore));
        _page = event.page;
      } catch (e) {
        emit(CashbackError('Error: $e'));
      }
    });
  }

  void fetchNext(String userId) {
    if (_hasMore) {
      add(FetchCashback(userId: userId, page: _page + 1, limit: _limit));
    }
  }

}
