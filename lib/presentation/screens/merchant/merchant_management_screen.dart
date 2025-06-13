import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pndb_admin/presentation/screens/merchant/merchant_detail_screen.dart';
import 'package:pndb_admin/presentation/viewmodels/fetch%20merchant/fetch_merchant_bloc.dart';

class MerchantManagementScreen extends StatelessWidget {
  const MerchantManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Merchant Management",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<FetchMerchantBloc, FetchMerchantState>(
                builder: (context, state) {
                  if (state is FetchMerchantLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FetchMerchantLoaded) {
                    final merchants = state.merchants;

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: merchants.length,
                      itemBuilder: (context, index) {
                        final merchant = merchants[index];

                        return GestureDetector(
                          onTap: () {
                            context.read<FetchMerchantBloc>().add(
                                  LoadMerchantDetails(
                                      merchant.merchantId ?? ''),
                                );

                            showCupertinoModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.black26,
                              builder: (context) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Dismiss on outside tap
                                },
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FractionallySizedBox(
                                        widthFactor: 0.5,
                                        child: GestureDetector(
                                          onTap:
                                              () {}, // absorb taps inside the sheet
                                          child: BlocBuilder<FetchMerchantBloc,
                                              FetchMerchantState>(
                                            builder: (context, state) {
                                              if (state
                                                  is FetchMerchantLoading) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (state
                                                      is FetchMerchantLoaded &&
                                                  state.selectedMerchant !=
                                                      null) {
                                                return MerchantDetailSheet(
                                                    merchant: state
                                                        .selectedMerchant!);
                                              } else if (state
                                                  is FetchMerchantError) {
                                                return Center(
                                                    child: Text(
                                                        "Error: ${state.message}"));
                                              }
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              expand: false,
                              enableDrag: false,
                              topRadius: const Radius.circular(20),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.teal.shade100,
                                    child: const Icon(Icons.store,
                                        color: Colors.teal),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          merchant.shopName ?? "Merchant Name",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "KYC: ${merchant.isVerified ? 'Verified' : 'Pending'}",
                                          style: TextStyle(
                                            color: merchant.isVerified
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is FetchMerchantError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else {
                    return const Center(child: Text("No merchants found."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
