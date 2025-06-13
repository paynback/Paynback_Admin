import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/user_model.dart';
import 'package:pndb_admin/data/services/user_service.dart';

part 'fetch_user_details_event.dart';
part 'fetch_user_details_state.dart';

class FetchUserDetailsBloc extends Bloc<FetchUserDetailsEvent, FetchUserDetailsState> {
  final UserService userService;
  FetchUserDetailsBloc({required this.userService}) : super(FetchUserDetailsInitial()) {
    on<GetUserDetailsEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userService.fetchUserDetailsByUid(event.uid);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError('Failed to fetch user details'));
      }
    });

    on<BlockOrUnblockUserEvent>((event, emit) async {
      try {
        emit(UserLoading());
        final service = UserService();
        await service.blockOrUnblockUser(
          userId: event.userId,
          shouldBlock: event.shouldBlock,
        );

        // Refetch the user data after update
        final updatedUser = await service.fetchUserDetailsByUid(event.userId);
        emit(UserLoaded(updatedUser));
      } catch (e) {
        emit(UserError("Failed to update block status: ${e.toString()}"));
      }
    });

  }
}
