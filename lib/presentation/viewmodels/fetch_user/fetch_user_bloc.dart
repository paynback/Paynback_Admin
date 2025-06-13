import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/user_model.dart';
import 'package:pndb_admin/data/services/user_service.dart';

part 'fetch_user_event.dart';
part 'fetch_user_state.dart';

class FetchUserBloc extends Bloc<FetchUserEvent, FetchUserState> {
  final UserService userService = UserService();
  final int _limit = 20;
  FetchUserBloc() : super(FetchUserInitial()) {
    on<FetchUser>((event, emit) async {
      try {
        if (event.page == 1) emit(FetchUserLoading());

        final users = await userService.fetchUsers(page: event.page);

        final bool hasMore = users.length == _limit;

        emit(FetchUserLoaded(users: users, hasMore: hasMore, page: event.page));
      } catch (e) {
        emit(FetchUserError(message: e.toString()));
      }
    });
  }
}
