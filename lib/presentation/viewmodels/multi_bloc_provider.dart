import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/data/services/admin_login_service.dart';
import 'package:pndb_admin/data/services/all_merchant_service.dart';
import 'package:pndb_admin/data/services/channel_partner_service.dart';
import 'package:pndb_admin/data/services/user_service.dart';
import 'package:pndb_admin/presentation/viewmodels/fetch%20merchant/fetch_merchant_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/fetch_channel_partners/fetch_channel_partners_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/fetch_user/fetch_user_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/fetch_user_details/fetch_user_details_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/login%20bloc/login_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/qr/downloaded_qr/downloaded_qr_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/qr/qr%20managemenet/qr_management_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/qr/assigned_qr/assigned_qr_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/submit_settlement/submit_settlement_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/verify%20merchant/verify_merchant_bloc.dart';

class AppMultiBlocProvider {
  static MultiBlocProvider build({
    required Widget child,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => LoginBloc(LoginService())),
        BlocProvider<FetchMerchantBloc>(
            create: (_) => FetchMerchantBloc(merchantService: MerchantService())
              ..add(LoadMerchants())),
        BlocProvider<VerifyMerchantBloc>(
            create: (_) => VerifyMerchantBloc(MerchantService())),
        BlocProvider(
            create: (_) => QrManagementBloc()..add(FetchGeneratedQrCodes())),
        BlocProvider(
            create: (_) => DownloadedQrBloc()..add(FetchDownloadedQrs())),
        BlocProvider<AssignedQrBloc>(
          create: (_) => AssignedQrBloc()..add(FetchAssignedQrCodes()),
        ),
        BlocProvider<FetchUserBloc>(
          create: (_) => FetchUserBloc()..add(FetchUser()),
        ),
        BlocProvider<FetchUserDetailsBloc>(
          create: (_) => FetchUserDetailsBloc(userService: UserService()),
        ),
        BlocProvider<SubmitSettlementBloc>(
          create: (_) => SubmitSettlementBloc(),
        ),
        BlocProvider<FetchChannelPartnersBloc>(
          create: (_) => FetchChannelPartnersBloc(api: ChannelPartnerService())..add(FetchChannelPartnersRequested()),
        ),
      ],
      child: child,
    );
  }
}
