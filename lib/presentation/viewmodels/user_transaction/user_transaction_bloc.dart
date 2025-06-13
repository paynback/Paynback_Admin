import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/user_transaction_model.dart';
import 'package:pndb_admin/data/services/user_service.dart';

part 'user_transaction_event.dart';
part 'user_transaction_state.dart';

class UserTransactionBloc extends Bloc<UserTransactionEvent, UserTransactionState> {
  final UserService userService;

  final List<UserTransactionModel> _allTransactions = [];
  int _page = 1;
  final int _limit = 20;
  bool _hasMore = true;
  
  UserTransactionBloc({required this.userService}) : super(UserTransactionInitial()) {
    on<FetchTransactions>((event, emit) async {
      if (!_hasMore && event.page != 1) return;

      if (event.page == 1) {
        emit(TransactionLoading());
        _allTransactions.clear();
        _hasMore = true;
      }

      try {
        final newTransactions = await userService.fetchTransactions(
          userId: event.userId,
          page: event.page,
          limit: event.limit,
        );

        _hasMore = newTransactions.length == _limit;
        _allTransactions.addAll(newTransactions);

        emit(TransactionLoaded(transactions: _allTransactions, hasMore: _hasMore));
        _page = event.page;
      } catch (e) {
        emit(TransactionError('Error: $e'));
      }
    });
  }

  void fetchNext(String userId) {
    if (_hasMore) {
      add(FetchTransactions(userId: userId, page: _page + 1, limit: _limit));
    }
  }
  
}
