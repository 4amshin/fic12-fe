import 'package:fic12_fe/core/extensions/build_context_ext.dart';
import 'package:fic12_fe/data/data_resources/auth_local_data_source.dart';
import 'package:fic12_fe/presentation/auth/pages/login_page.dart';
import 'package:fic12_fe/presentation/home/pages/dashboard_page.dart';
import 'package:fic12_fe/presentation/setting/pages/manage_printer_page.dart';
import 'package:fic12_fe/presentation/setting/pages/save_server_key_page.dart';
import 'package:fic12_fe/presentation/setting/pages/sync_data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/spaces.dart';
import '../../home/bloc/logout/logout_bloc.dart';
import 'manage_product_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.push(const DashboardPage());
            },
          ),
          title: const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  MenuButton(
                    iconPath: Assets.images.manageProduct.path,
                    label: 'Setting Product',
                    onPressed: () => context.push(const ManageProductPage()),
                    isImage: true,
                  ),
                  const SpaceWidth(15.0),
                  MenuButton(
                    iconPath: Assets.images.managePrinter.path,
                    label: 'Setting Printer',
                    onPressed: () {
                      context.push(const ManagePrinterPage());
                    },
                    isImage: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  MenuButton(
                    iconPath: Assets.images.manageQr.path,
                    label: 'QRIS Server Key',
                    onPressed: () => context.push(const SaveServerKeyPage()),
                    isImage: true,
                  ),
                  const SpaceWidth(15.0),
                  MenuButton(
                    iconPath: Assets.images.sync.path,
                    label: 'Sync Data',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SyncDataPage()));
                    },
                    isImage: true,
                  ),
                ],
              ),
            ),
            const SpaceHeight(60),
            BlocConsumer<LogoutBloc, LogoutState>(
              listener: (context, state) {
                state.maybeMap(
                  orElse: () {},
                  success: (_) {
                    AuthLocalDataSource().removeToken();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                );
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<LogoutBloc>().add(const LogoutEvent.logout());
                  },
                  child: const Text('Logout'),
                );
              },
            ),
            const Divider(),
          ],
        ));
  }
}
