import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/data/models/merchant_model.dart';
import 'package:pndb_admin/presentation/viewmodels/fetch%20merchant/fetch_merchant_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/verify%20merchant/verify_merchant_bloc.dart';

class MerchantDetailSheet extends StatefulWidget {
  final Merchant merchant;

  const MerchantDetailSheet({super.key, required this.merchant});

  @override
  State<MerchantDetailSheet> createState() => _MerchantDetailSheetState();
}

class _MerchantDetailSheetState extends State<MerchantDetailSheet> {
  late bool isVerified;
  late bool isBlocked;

  @override
  void initState() {
    super.initState();
    isVerified = widget.merchant.isVerified;
    isBlocked = widget.merchant.isBlocked;
  }

  Widget buildImage(String? url, String label, {double height = 120}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          height: height,
          width: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: url != null && url.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: height,
                    height: height,
                    errorBuilder: (_, __, ___) => buildPlaceholder(label),
                  ),
                )
              : buildPlaceholder(label),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildPlaceholder(String label) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_not_supported, size: 36, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            "$label Placeholder",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget buildHorizontalImageList(List<String> images) {
    if (images.isEmpty) {
      return Container(
        height: 100,
        color: Colors.grey[200],
        child: const Center(child: Text("No shop pictures available")),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final imgUrl = images[index];
          return Image.network(
            imgUrl,
            width: 120,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 120,
              height: 100,
              color: Colors.grey[200],
              child: const Center(child: Text("Image error")),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final merchant = widget.merchant;

    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Material(
          elevation: 6,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Buttons
                  BlocConsumer<VerifyMerchantBloc, VerifyMerchantState>(
                    listener: (context, state) {
                      if (state is MerchantVerified) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Merchant Verified Successfully")),
                        );

                        // Trigger refresh of merchant list
                        context
                            .read<FetchMerchantBloc>()
                            .add(LoadMerchants());

                        // Optionally close the modal after short delay
                        // Future.delayed(const Duration(milliseconds: 500), () {
                        //   Navigator.of(context).pop();
                        // });
                        
                      } else if (state is MerchantVerificationFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${state.error}")),
                        );
                      }
                    },
                    builder: (context, state) {
                      final bloc = context.read<VerifyMerchantBloc>();

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: merchant.isVerified ||
                                    state is VerifyingMerchant
                                ? null
                                : () {
                                    bloc.add(StartMerchantVerification(
                                        merchant.merchantId!));
                                  },
                            icon: const Icon(Icons.verified_user),
                            label: state is VerifyingMerchant
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text("Verify"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              isBlocked ? Icons.lock_open : Icons.block,
                              color: Colors.white,
                            ),
                            label: Text(isBlocked ? "Unblock" : "Block"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isBlocked ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Basic Info
                  Text(merchant.shopName?.toUpperCase() ?? "No Name",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Email: ${merchant.email ?? 'N/A'}"),
                  Text("Phone: ${merchant.phone ?? 'N/A'}"),
                  Text("Shop: ${merchant.shopName ?? 'N/A'}"),
                  Text("Category: ${merchant.category ?? 'N/A'}"),

                  const Divider(height: 32),

                  // Shop Pictures
                  const Text("Shop Pictures",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  buildHorizontalImageList(merchant.shopPictures),
                  const SizedBox(height: 16),

                  // Owner Photo
                  buildImage(merchant.profilePicture, "Owner Photo"),

                  const Divider(height: 32),

                  // Aadhaar
                  Text("Aadhaar Number: ${merchant.aadhaarNumber ?? 'N/A'}"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      buildImage(merchant.aadhaarFront, "Aadhaar Front"),
                      const SizedBox(width: 20),
                      buildImage(merchant.aadhaarBack, "Aadhaar Back"),
                    ],
                  ),

                  const Divider(height: 32),

                  // PAN
                  Text("PAN Number: ${merchant.panNumber ?? 'N/A'}"),
                  const SizedBox(height: 8),
                  buildImage(merchant.panImage, "PAN Image"),

                  const Divider(height: 32),

                  // Bank Details
                  Text("Bank Name: ${merchant.bankName ?? 'N/A'}"),
                  Text(
                      "Account Number: ${merchant.bankAccountNumber ?? 'N/A'}"),
                  Text("IFSC Code: ${merchant.ifscCode ?? 'N/A'}"),

                  const SizedBox(height: 24),

                  // Status
                  Row(
                    children: [
                      const Text("KYC Status: "),
                      Icon(
                        merchant.isKyc ? Icons.verified : Icons.cancel,
                        color: merchant.isKyc ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 16),
                      const Text("Blocked: "),
                      Icon(
                        isBlocked ? Icons.block : Icons.check_circle_outline,
                        color: isBlocked ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 16),
                      const Text("Verified: "),
                      Icon(
                        isVerified ? Icons.verified : Icons.verified_outlined,
                        color: isVerified ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
