part of 'verify_merchant_bloc.dart';

@immutable
sealed class VerifyMerchantEvent {}

class StartMerchantVerification extends VerifyMerchantEvent {
  final String merchantId;

  StartMerchantVerification(this.merchantId);
}