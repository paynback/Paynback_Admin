part of 'update_all_commission_bloc.dart';

@immutable
sealed class UpdateAllCommissionEvent {}

class UpdateCommissionRate extends UpdateAllCommissionEvent {
  final int rate;
  UpdateCommissionRate(this.rate);
}