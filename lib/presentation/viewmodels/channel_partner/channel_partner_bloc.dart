import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/data/services/channel_partner_service.dart';


// --- States ---
abstract class ChannelPartnerCreationState {}

class ChannelPartnerCreationInitial extends ChannelPartnerCreationState {}

class ChannelPartnerCreationLoading extends ChannelPartnerCreationState {}

class ChannelPartnerCreationSuccess extends ChannelPartnerCreationState {}

class ChannelPartnerCreationFailure extends ChannelPartnerCreationState {
  final String error;
  ChannelPartnerCreationFailure(this.error);
}

// --- Cubit ---
class ChannelPartnerCreationCubit extends Cubit<ChannelPartnerCreationState> {
  ChannelPartnerCreationCubit() : super(ChannelPartnerCreationInitial());

  Future<void> createPartner({
    required String name,
    required String phone,
    required String idProofFront,
    required String idProofBack,
    required String district,
    required String email,
    required String? profilePicture,
  }) async {
    emit(ChannelPartnerCreationLoading());

    try {
      final success = await ChannelPartnerService().create(
        name: name,
        phone: phone,
        idProofFront: idProofFront,
        idProofBack: idProofBack,
        profilePicture: profilePicture,
        district: district,
        email: email,
      );

      if (success) {
        emit(ChannelPartnerCreationSuccess());
      } else {
        emit(ChannelPartnerCreationFailure("Unknown error occurred"));
      }
    } catch (e) {
      emit(ChannelPartnerCreationFailure(e.toString()));
    }
  }
}
