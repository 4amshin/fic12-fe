import 'package:fic12_fe/core/assets/assets.gen.dart';
import 'package:fic12_fe/core/components/menu_button.dart';
import 'package:fic12_fe/core/components/spaces.dart';
import 'package:fic12_fe/core/constants/colors.dart';
import 'package:fic12_fe/core/extensions/build_context_ext.dart';
import 'package:fic12_fe/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:fic12_fe/presentation/home/models/order_item.dart';
import 'package:fic12_fe/presentation/home/pages/dashboard_page.dart';
import 'package:fic12_fe/presentation/order/bloc/order/order_bloc.dart';
import 'package:fic12_fe/presentation/order/widgets/order_card.dart';
import 'package:fic12_fe/presentation/order/widgets/payment_cash_dialog.dart';
import 'package:fic12_fe/presentation/order/widgets/payment_qris_dialog.dart';
import 'package:fic12_fe/presentation/order/widgets/process_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final indexValue = ValueNotifier(0);

  List<OrderItem> orders = [];

  int totalPrice = 0;
  int calculateTotalPrice(List<OrderItem> orders) {
    return orders.fold(
        0,
        (previousValue, element) =>
            previousValue + element.product.price * element.quantity);
  }

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.push(const DashboardPage());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Order Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //show dialog save order
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Open Bill'),
                      content: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Order Name',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            //clear checkout
                            context.read<CheckoutBloc>().add(
                                  const CheckoutEvent.started(),
                                );
                            //open bill success snack bar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Open Bill Success'),
                                backgroundColor: AppColors.primary,
                              ),
                            );

                            context.pushReplacement(const DashboardPage());
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.save_as_outlined),
          ),
          const SpaceWidth(8),
        ],
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          return state.maybeWhen(orElse: () {
            return const Center(
              child: Text('No Data'),
            );
          }, success: (data, qty, total) {
            if (data.isEmpty) {
              return const Center(
                child: Text('No Data'),
              );
            }

            totalPrice = total;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: data.length,
              separatorBuilder: (context, index) => const SpaceHeight(20.0),
              itemBuilder: (context, index) => OrderCard(
                padding: paddingHorizontal,
                data: data[index],
                onDeleteTap: () {},
              ),
            );
          });
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return const SizedBox.shrink();
                  },
                  success: (data, qty, total) {
                    return ValueListenableBuilder(
                      valueListenable: indexValue,
                      builder: (context, value, _) => Row(
                        children: [
                          MenuButton(
                            iconPath: Assets.icons.cash.path,
                            label: 'CASH',
                            isActive: value == 1,
                            onPressed: () {
                              indexValue.value = 1;
                              context
                                  .read<OrderBloc>()
                                  .add(OrderEvent.addPaymentMethod(
                                    paymentMethod: 'Tunai',
                                    orders: data,
                                  ));
                            },
                          ),
                          const SpaceWidth(16.0),
                          MenuButton(
                            iconPath: Assets.icons.qrCode.path,
                            label: 'QR',
                            isActive: value == 2,
                            onPressed: () {
                              indexValue.value = 2;
                              context
                                  .read<OrderBloc>()
                                  .add(OrderEvent.addPaymentMethod(
                                    paymentMethod: 'QRIS',
                                    orders: data,
                                  ));
                            },
                          ),
                          const SpaceWidth(16.0),
                          MenuButton(
                            iconPath: Assets.icons.debit.path,
                            label: 'TRANSFER',
                            isActive: value == 3,
                            onPressed: () {
                              indexValue.value = 3;
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SpaceHeight(20.0),
            ProcessButton(
              price: 0,
              onPressed: () async {
                if (indexValue.value == 0) {
                } else if (indexValue.value == 1) {
                  showDialog(
                    context: context,
                    builder: (context) => PaymentCashDialog(
                      price: totalPrice,
                    ),
                  );
                } else if (indexValue.value == 2) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => PaymentQrisDialog(
                      price: totalPrice,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
