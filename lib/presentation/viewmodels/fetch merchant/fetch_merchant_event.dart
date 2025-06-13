part of 'fetch_merchant_bloc.dart';

@immutable
sealed class FetchMerchantEvent {}

class LoadMerchants extends FetchMerchantEvent {
  final int page;

  LoadMerchants({this.page = 1});
}

class LoadMerchantDetails extends FetchMerchantEvent {
  final String merchantId;

  LoadMerchantDetails(this.merchantId);
}