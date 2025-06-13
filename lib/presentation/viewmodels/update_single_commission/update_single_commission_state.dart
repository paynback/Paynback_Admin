part of 'update_single_commission_bloc.dart';

@immutable
sealed class UpdateSingleCommissionState {}

final class UpdateSingleCommissionInitial extends UpdateSingleCommissionState {}

class UpdateSingleCommissionLoading extends UpdateSingleCommissionState {}

class UpdateSingleCommissionSuccess extends UpdateSingleCommissionState {}

class UpdateSingleCommissionFailure extends UpdateSingleCommissionState {
  final String error;
  UpdateSingleCommissionFailure(this.error);
}