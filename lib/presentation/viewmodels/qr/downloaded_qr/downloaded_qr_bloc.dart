import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pndb_admin/data/models/bulk_qr_model.dart';
import 'package:pndb_admin/data/services/qr_service.dart';

part 'downloaded_qr_event.dart';
part 'downloaded_qr_state.dart';

class DownloadedQrBloc extends Bloc<DownloadedQrEvent, DownloadedQrState> {
  DownloadedQrBloc() : super(DownloadedQrInitial()) {
    on<FetchDownloadedQrs>(_onFetchDownloadedQrCodes);
    on<GenerateDownloadedQrs>(_onDownloadedQrs);
  }

  Future<void> _onFetchDownloadedQrCodes(
    FetchDownloadedQrs event,
    Emitter<DownloadedQrState> emit,
  ) async {
    emit(DownloadedQrLoading());
    try {
      final qrCodes = await QrService.fetchDownloadedQrs();
      emit(DownloadedQrLoaded(qrCodes));
    } catch (e) {
      debugPrint("Error fetching downloaded QR codes: $e");
      emit(DownloadedQrError("Failed to load downloaded QR codes"));
    }
  }

  Future<void> _onDownloadedQrs(
    GenerateDownloadedQrs event,
    Emitter<DownloadedQrState> emit,
  ) async {
    emit(DownloadedQrLoading());
    try {
      await QrService.generateAndShowPdfWithDownloadedQrs(event.limit);
      final qrCodes = await QrService.fetchDownloadedQrs(); // Fetch new codes
      emit(DownloadedQrLoaded(qrCodes));
      add(FetchDownloadedQrs()); // trigger a refresh
    } catch (e) {
      debugPrint("Error generating downloaded QR codes: $e");
      emit(DownloadedQrError("Failed to generate downloaded QR codes"));
    }
  }
}
