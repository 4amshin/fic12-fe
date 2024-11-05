import 'dart:developer';

import 'package:fic12_fe/core/extensions/build_context_ext.dart';
import 'package:fic12_fe/data/data_resources/auth_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../widgets/menu_printer_button.dart';
import '../widgets/menu_printer_content.dart';

class ManagePrinterPage extends StatefulWidget {
  const ManagePrinterPage({super.key});

  @override
  State<ManagePrinterPage> createState() => _ManagePrinterPageState();
}

class _ManagePrinterPageState extends State<ManagePrinterPage> {
  int selectedIndex = 0;

  String macName = '';
  String? macConnected;

  bool connected = false;
  // List<BluetoothInfo> items = [];

  String optionPrintType = "58 mm";
  List<String> options = ["58 mm", "80 mm"];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    loadDataPrinter();
  }

  loadDataPrinter() async {
    macConnected = await AuthLocalDataSource().getPrinter();
    if (macConnected != '') {
      macName = macConnected!;
      await connect(macName);
    }

    getBluetooths();
    setState(() {});
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    int percentBattery = 0;

    try {
      // platformVersion = await PrintBluetoothThermal.platformVersion;

      // percentBattery = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    // final bool result = await PrintBluetoothThermal.bluetoothEnabled;
  }

  Future<void> getBluetooths() async {
    setState(() {
      // items = [];
    });
    var status2 = await Permission.bluetoothScan.status;
    if (status2.isDenied) {
      await Permission.bluetoothScan.request();
    }
    var status = await Permission.bluetoothConnect.status;
    if (status.isDenied) {
      await Permission.bluetoothConnect.request();
    }

    // final List<BluetoothInfo> listResult =
    //     await PrintBluetoothThermal.pairedBluetooths;

    setState(() {
      // items = listResult;
    });
  }

  Future<void> connect(String mac) async {
    setState(() {
      connected = false;
    });
    final bool result =
        // await PrintBluetoothThermal.connect(macPrinterAddress: mac);

        connected = true;
    AuthLocalDataSource().savePrinter(mac);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Printer connected with Name $mac'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Future<void> disconnect() async {
    // final bool status = await PrintBluetoothThermal.disconnect;
    setState(() {
      connected = false;
    });
    // log("status disconnect $status");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Management'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Container(
            width: context.deviceWidth / 2,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MenuPrinterButton(
                  label: 'Search',
                  onPressed: () {
                    getBluetooths();
                    selectedIndex = 0;
                    setState(() {});
                  },
                  isActive: selectedIndex == 0,
                ),
              ],
            ),
          ),
          const SpaceHeight(34.0),
          // _Body(
          //   macName: macName,
          //   datas: items,
          //   clickHandler: (mac) async {
          //     macName = mac;
          //     await connect(mac);
          //     setState(() {});
          //   },
          // ),
        ],
      ),
    );
  }
}

// class _Body extends StatelessWidget {
//   final String macName;
//   // final List<BluetoothInfo> datas;

//   final Function(String) clickHandler;

//   const _Body({
//     Key? key,
//     required this.macName,
//     // required this.datas,
//     required this.clickHandler,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (datas.isEmpty) {
//       return const Text('No data available');
//     } else {
//       return Container(
//         padding: const EdgeInsets.all(24.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: AppColors.card, width: 2),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: datas.length,
//           separatorBuilder: (context, index) => const SpaceHeight(16.0),
//           itemBuilder: (context, index) => InkWell(
//             onTap: () {
//               clickHandler(datas[index].macAdress);
//             },
//             child: MenuPrinterContent(
//               isSelected: macName == datas[index].macAdress,
//               data: datas[index],
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }
