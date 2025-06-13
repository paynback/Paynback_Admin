import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/bulk_qr_model.dart';
import 'package:pndb_admin/data/services/qr_service.dart';

part 'assigned_qr_event.dart';
part 'assigned_qr_state.dart';

class AssignedQrBloc extends Bloc<AssignedQrEvent, AssignedQrState> {
  AssignedQrBloc() : super(AssignedQrInitial()) {
    on<FetchAssignedQrCodes>(_onFetchAssignedQrs);
  }
}

Future<void> _onFetchAssignedQrs(
  FetchAssignedQrCodes event,
  Emitter<AssignedQrState> emit,
) async {
  emit(AssignedQrLoading());
  try {
    final qrCodes = await QrService.fetchAssignedQrs();
    emit(AssignedQrLoaded(qrCodes));
  } catch (e) {
    print("Bloc Error in _onFetchAssignedQrs: $e");
    emit(AssignedQrError("Failed to fetch assigned QR codes"));
  }
}
