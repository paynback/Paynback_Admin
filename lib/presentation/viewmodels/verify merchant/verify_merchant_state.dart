part of 'verify_merchant_bloc.dart';

@immutable
sealed class VerifyMerchantState {}

final class VerifyMerchantInitial extends VerifyMerchantState {}


final class VerifyingMerchant extends VerifyMerchantState {}

final class MerchantVerified extends VerifyMerchantState {}

final class MerchantVerificationFailed extends VerifyMerchantState {
  final String error;

  MerchantVerificationFailed(this.error);
}