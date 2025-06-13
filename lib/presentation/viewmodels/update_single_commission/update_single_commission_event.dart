part of 'update_single_commission_bloc.dart';

@immutable
sealed class UpdateSingleCommissionEvent {}

class UpdateSingleCommissionRate extends UpdateSingleCommissionEvent {
  final int rate;
  final String merchantId;
  UpdateSingleCommissionRate(this.rate,this.merchantId);
}