import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:fic12_fe/core/extensions/int_ext.dart';
import 'package:fic12_fe/core/extensions/string_ext.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

import '../../presentation/home/models/order_item.dart';

class CwbPrint {
  CwbPrint._init();

  static final CwbPrint instance = CwbPrint._init();

  Future<List<int>> printOrder(
    List<OrderItem> products,
    int totalQuantity,
    int totalPrice,
    String paymentMethod,
    int nominalBayar,
    String namaKasir,
  ) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    final ByteData data = await rootBundle.load('assets/logo/mylogo.png');
    final Uint8List bytesData = data.buffer.asUint8List();
    final img.Image? orginalImage = img.decodeImage(bytesData);
    bytes += generator.reset();

    if (orginalImage != null) {
      final img.Image grayscalledImage = img.grayscale(orginalImage);
      final img.Image resizedImage =
          img.copyResize(grayscalledImage, width: 240);
      bytes += generator.imageRaster(resizedImage, align: PosAlign.center);
      bytes += generator.feed(2);
    }

    bytes += generator.text('Coffee With Bahri',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    bytes += generator.text('Flutter Street, Dart 2024',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.text(
        'Date : ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    bytes += generator.feed(1);
    bytes += generator.text('Order Items:',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    for (final product in products) {
      bytes += generator.text(product.product.name,
          styles: const PosStyles(align: PosAlign.left));

      bytes += generator.row([
        PosColumn(
          text: '${product.product.price} x ${product.quantity}',
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '${product.product.price * product.quantity}'.currencyFormatRp,
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.feed(1);

    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: totalPrice.currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Pay',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: nominalBayar.currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Payment Method',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: paymentMethod == 'QRIS' ? 'QRIS' : 'Cash',
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.feed(1);
    bytes += generator.text('Thank you for coming',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(3);

    return bytes;
  }
}
