part of 'fetch_merchant_bloc.dart';

@immutable
sealed class FetchMerchantState {}

final class FetchMerchantInitial extends FetchMerchantState {}

final class FetchMerchantLoading extends FetchMerchantState {}

final class FetchMerchantLoaded extends FetchMerchantState {
  final List<Merchant> merchants;
  final int currentPage;
  final Merchant? selectedMerchant;

  FetchMerchantLoaded({
    required this.merchants,
    required this.currentPage,
    this.selectedMerchant,
  });
}


final class FetchMerchantDetailLoaded extends FetchMerchantState {
  final Merchant merchant;

  FetchMerchantDetailLoaded({required this.merchant});
}

final class FetchMerchantError extends FetchMerchantState {
  final String message;

  FetchMerchantError(this.message);
}
