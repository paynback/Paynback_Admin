part of 'commission_bloc.dart';

@immutable
sealed class CommissionEvent {}

class FetchMerchants extends CommissionEvent {}