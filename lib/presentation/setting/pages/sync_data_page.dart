import 'dart:developer';

import 'package:fic12_fe/core/components/spaces.dart';
import 'package:fic12_fe/core/extensions/build_context_ext.dart';
import 'package:fic12_fe/data/data_resources/product_local_data_source.dart';
import 'package:fic12_fe/presentation/home/bloc/category/category_bloc.dart';
import 'package:fic12_fe/presentation/home/bloc/product/product_bloc.dart';
import 'package:fic12_fe/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Data'),
        centerTitle: true,
      ),
      //textfield untuk input server key
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                success: (data) async {
                  await ProductLocalDataSource.instance.removeAllProduct();
                  await ProductLocalDataSource.instance
                      .insertAllProduct(data.products);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text(
                        'Sync data product success',
                      ),
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton(
                      onPressed: () {
                        log("Syncing Data Product...");
                        context
                            .read<ProductBloc>()
                            .add(const ProductEvent.getProduct());
                      },
                      child: const Text('Sync Data Product'));
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
          const SpaceHeight(20),
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                success: (_) async {
                  // await ProductLocalDataSource.instance.removeAllProduct();
                  // await ProductLocalDataSource.instance
                  //     .insertAllProduct(_.products.toList());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text(
                        'Sync data orders success',
                      )));
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton(
                      onPressed: () {
                        context
                            .read<SyncOrderBloc>()
                            .add(const SyncOrderEvent.sendOrder());
                      },
                      child: const Text('Sync Data Orders'));
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
          const SpaceHeight(20),
          BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                loaded: (data) async {
                  await ProductLocalDataSource.instance.removeAllCategories();
                  await ProductLocalDataSource.instance
                      .insertAllCategories(data.categories);

                  context
                      .read<CategoryBloc>()
                      .add(const CategoryEvent.getCategoriesLocal());
                  context.pop();

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text(
                        'Sync data categories success',
                      )));
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton(
                      onPressed: () {
                        context
                            .read<CategoryBloc>()
                            .add(const CategoryEvent.getCategories());
                      },
                      child: const Text('Sync Data Categories'));
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
