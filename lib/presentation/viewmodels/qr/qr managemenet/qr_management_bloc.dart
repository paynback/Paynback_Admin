import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/bulk_qr_model.dart';
import 'package:pndb_admin/data/services/qr_service.dart';

part 'qr_management_event.dart';
part 'qr_management_state.dart';

class QrManagementBloc extends Bloc<QrManagementEvent, QrManagementState> {
  QrManagementBloc() : super(QrManagementInitial()) {
    on<FetchGeneratedQrCodes>(_onFetchGeneratedQrCodes);
    on<GenerateQrs>(_onGenerateQrs);
  }
  

  Future<void> _onFetchGeneratedQrCodes(
    FetchGeneratedQrCodes event,
    Emitter<QrManagementState> emit,
  ) async {
    emit(QrManagementLoading());
    try {
      final qrCodes = await QrService.fetchGeneratedQrs();
      emit(QrManagementLoaded(qrCodes));
    } catch (e) {
      debugPrint("Error fetching generated QR codes: $e");
      emit(QrManagementError("Failed to load generated QR codes"));
    }
  }

  Future<void> _onGenerateQrs(
    GenerateQrs event,
    Emitter<QrManagementState> emit,
  ) async {
    emit(QrManagementLoading());

    try {
      await QrService.generateQrs(event.count);

      // Small delay before re-fetch
      await Future.delayed(const Duration(seconds: 1));

      final qrCodes = await QrService.fetchGeneratedQrs();
      emit(QrManagementLoaded(qrCodes));
    } catch (e) {
      debugPrint("Error generating QR codes: $e");
      emit(QrManagementError("Failed to generate QR codes"));
    }
  }
}
