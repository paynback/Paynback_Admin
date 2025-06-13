import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/channel_partners_merchants/channel_partners_merchants_bloc.dart';

class PartnersMerchents extends StatelessWidget {
  const PartnersMerchents({super.key, required this.channelPartnerId});
  final String channelPartnerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChannelPartnersMerchantsBloc()
        ..add(LoadChannelPartnerMerchants(partnerId: channelPartnerId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Partner Merchants')),
        body: BlocBuilder<ChannelPartnersMerchantsBloc, ChannelPartnersMerchantsState>(
          builder: (context, state) {
            if (state is ChannelPartnersMerchantsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChannelPartnersMerchantsLoaded) {
              if (state.merchants.isEmpty) {
                return const Center(child: Text('No merchants found'));
              }

              return ListView.builder(
                itemCount: state.merchants.length,
                itemBuilder: (context, index) {
                  final merchant = state.merchants[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(merchant.profilePicture!),
                    ),
                    title: Text(merchant.shopName!),
                    subtitle: Text('${merchant.email}\n${merchant.phone}'),
                    isThreeLine: true,
                  );
                },
              );
            } else if (state is ChannelPartnersMerchantsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
