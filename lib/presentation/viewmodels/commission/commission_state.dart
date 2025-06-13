part of 'commission_bloc.dart';

@immutable
sealed class CommissionState {}

final class CommissionInitial extends CommissionState {}

class CommissionLoading extends CommissionState {}

class CommissionLoaded extends CommissionState {
  final List<CommissionMerchantModel> merchants;
  CommissionLoaded(this.merchants);
}

class CommissionError extends CommissionState {
  final String error;
  CommissionError(this.error);
}