import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/data/models/channel_partner_model.dart';
import 'package:pndb_admin/data/services/channel_partner_service.dart';
import 'package:pndb_admin/presentation/screens/channel_partner/create_partner_dialog/create_partner_dialog.dart';
import 'package:pndb_admin/presentation/screens/channel_partner/partners_merchents/partners_merchents.dart';
import 'package:pndb_admin/presentation/viewmodels/channel_partner/channel_partner_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/channel_partner_status/channel_partner_status_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/fetch_channel_partners/fetch_channel_partners_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelPartner extends StatelessWidget {
  const ChannelPartner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 80,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667EEA),
                    Color(0xFF764BA2),
                  ],
                ),
              ),
            ),
            title: const Text(
              'Channel Partners',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),

          // Partners Grid
          BlocBuilder<FetchChannelPartnersBloc, FetchChannelPartnersState>(
            builder: (context, state) {
              if (state is FetchChannelPartnersLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is FetchChannelPartnersFailure) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${state.error}')),
                );
              } else if (state is FetchChannelPartnersSuccess) {
                final channelPartners = state.partners;
                if (channelPartners.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No channel partners found')),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      childAspectRatio: 0.48,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final partner = channelPartners[index];
                        return _buildPartnerCard(partner, context);
                      },
                      childCount: channelPartners.length,
                    ),
                  ),
                );
              }

              // Initial state or any other states
              return const SliverFillRemaining(
                child: Center(child: Text('Please wait...')),
              );
            },
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => ChannelPartnerCreationCubit(),
                child: CreatePartnerDialog(),
              ),
            );
          },
          backgroundColor: const Color(0xFF667EEA),
          elevation: 8,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'New Partner',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerCard(ChannelPartnerModel partner, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Image
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: partner.profilePicture.isNotEmpty 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                partner.profilePicture,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[500],
                            ),
                    ),
                    BlocProvider(
                      create: (_) => ChannelPartnerStatusBloc(),
                      child: BlocConsumer<ChannelPartnerStatusBloc, ChannelPartnerStatusState>(
                        listener: (context, state) {
                          if(state is ChannelPartnerStatusSuccess){
                            context.read<FetchChannelPartnersBloc>().add(FetchChannelPartnersRequested());
                          }
                        },
                        builder: (context, state) {
                          return Material(
                            color: partner.isBlocked == true? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {
                                final partnerId = partner.channelPartnerId;
                                final isCurrentlyBlocked = partner.isBlocked;

                                context.read<ChannelPartnerStatusBloc>().add(
                                      ToggleBlockStatus(
                                        id: partnerId,
                                        isBlocked: !isCurrentlyBlocked,
                                      ),
                                    );
                              },
                              borderRadius: BorderRadius.circular(10),
                              splashColor: Colors.white38,
                              child: Container(
                                height: 30,
                                width: 80,
                                alignment: Alignment.center,
                                child: Text(
                                  state is ChannelPartnerStatusLoading
                                      ? 'Loading...'
                                      : partner.isBlocked
                                          ? 'Unblock'
                                          : 'Block',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 12),

                // Name
                Center(
                  child: Text(
                    partner.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 12),

                // Phone
                _buildInfoRow(Icons.phone, partner.phone),
                const SizedBox(height: 8),

                // Email
                _buildInfoRow(Icons.email, partner.email),
                const SizedBox(height: 8),

                // Location
                _buildInfoRow(Icons.location_on, partner.district),
                const SizedBox(height: 8),

                // Username
                _buildInfoRow(Icons.account_circle, partner.userName),
                const SizedBox(height: 8),

                // Password
                _buildInfoRow(Icons.lock, partner.password),

                const SizedBox(height: 12),
                // ID Image
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: partner.idProofFront.isNotEmpty 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                partner.idProofFront,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[500],
                            ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: partner.idProofBack.isNotEmpty 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                partner.idProofBack,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[500],
                            ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                TextButton(
                  onPressed: () async {
                    final String shareText = '''
                      *Paynback Channel Partner Login Credentials*

                       Username: ${partner.userName}
                       Password: ${partner.password}

                       Download the Channel Partner App:
                      https://example.com/download-app
                      ''';

                    if (kIsWeb) {
                      // For web: open WhatsApp with prefilled text
                      final url = Uri.encodeFull('https://wa.me/?text=$shareText');
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                    } else {
                      await Share.share(shareText);
                    }
                  },
                  child: const Text('Share Credentials'),
                ),

                SizedBox(height: 10,),

                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return PartnersMerchents(channelPartnerId: partner.channelPartnerId,);
                    },));
                  }, 
                  child: Text('View Merchents')
                ),

                SizedBox(height: 10,),

                TextButton(
                  onPressed: () async {
                    try {
                      final newPassword = await ChannelPartnerService().regeneratePassword(partner.channelPartnerId);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('New Password: $newPassword')),
                      );
                      context.read<FetchChannelPartnersBloc>().add(FetchChannelPartnersRequested());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  child: Text('Change password'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text,) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 5;
    if (screenWidth > 800) return 4;
    if (screenWidth > 600) return 3;
    return 2;
  }
}
