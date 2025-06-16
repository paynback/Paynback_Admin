import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/services/dashboard_service.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService service;

  DashboardBloc(this.service) : super(DashboardInitial()) {
    on<FetchDashboardData>((event, emit) async {

      print('bloc working');

      emit(DashboardLoading());

      try {
        final results = await Future.wait([
          service.fetchCount('/total-user-count'),
          service.fetchCount('/total-merchant-count'),
          service.fetchCount('/total-cashback-count'),
          service.fetchCount('/total-commission-count'),
          service.fetchCount('/total-sales-count'),
        ]);

        final data = {
          'Total Users': results[0],
          'Total Merchants': results[1],
          'Cashback Given': results[2],
          'Commission Earned': results[3],
          'Sales': results[4],
        };

        print('fetched data $data');

        emit(DashboardLoaded(data));
      } catch (e) {
        emit(DashboardError('something went wrong ${e.toString()}'));
      }
    });
  }
}
