part of 'update_all_commission_bloc.dart';

@immutable
sealed class UpdateAllCommissionState {}

final class UpdateAllCommissionInitial extends UpdateAllCommissionState {}

class UpdateLoading extends UpdateAllCommissionState {}

class UpdateSuccess extends UpdateAllCommissionState {}

class UpdateFailure extends UpdateAllCommissionState {
  final String error;
  UpdateFailure(this.error);
}