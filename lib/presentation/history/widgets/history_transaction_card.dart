import 'package:fic12_fe/core/extensions/int_ext.dart';
import 'package:fic12_fe/core/extensions/string_ext.dart';
import 'package:fic12_fe/presentation/order/models/order_model.dart';
import 'package:flutter/material.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../core/constants/colors.dart';

class HistoryTransactionCard extends StatelessWidget {
  final OrderModel data;
  final EdgeInsetsGeometry? padding;

  const HistoryTransactionCard({
    super.key,
    required this.data,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: padding,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 48.0,
              blurStyle: BlurStyle.outer,
              spreadRadius: 0,
              color: AppColors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(0.0),
          ),
          title: Row(
            children: [
              Assets.icons.payments.svg(),
              const SizedBox(width: 12.0),
              Text(
                '${data.transactionTime.toFormattedTime} - ${data.paymentMethod == 'QRIS' ? 'QRIS' : 'Cash'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                data.totalPrice.currencyFormatRp,
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.orders.length,
              itemBuilder: (context, index) {
                final item = data.orders[index];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text(
                    '${item.quantity} x ${item.product.price.currencyFormatRp}',
                  ),
                  trailing: Text(
                    '${item.quantity * item.product.price}'.currencyFormatRp,
                    style: const TextStyle(
                      color: AppColors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
