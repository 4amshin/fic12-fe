import 'package:fic12_fe/core/assets/assets.gen.dart';
import 'package:fic12_fe/core/components/menu_button.dart';
import 'package:fic12_fe/core/components/search_input.dart';
import 'package:fic12_fe/core/components/spaces.dart';
import 'package:fic12_fe/presentation/home/bloc/product/product_bloc.dart';
import 'package:fic12_fe/presentation/home/widgets/product_card.dart';
import 'package:fic12_fe/presentation/home/widgets/product_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final indexValue = ValueNotifier(0);

  @override
  void initState() {
    context.read<ProductBloc>().add(const ProductEvent.getLocal());
    //Logic AuthLocalDataSource.getPrinter() - See in FIC12_STARTER
    super.initState();
  }

  void onCategoryTap(int index) {
    searchController.clear();
    indexValue.value = index;
    String category = 'all';
    switch (index) {
      case 0:
        category = 'all';
        break;
      case 1:
        category = 'drink';
        break;
      case 2:
        category = 'food';
        break;
      case 3:
        category = 'snack';
        break;
    }
    context
        .read<ProductBloc>()
        .add(ProductEvent.getByCategory(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Menu Cafe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.note_alt_rounded),
          ),
          const SpaceWidth(8)
        ],
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SearchInput(
            controller: searchController,
            onChanged: (value) {
              if (value.length > 3) {
                context
                    .read<ProductBloc>()
                    .add(ProductEvent.searchProduct(query: value));
              }
              if (value.isEmpty) {
                context
                    .read<ProductBloc>()
                    .add(const ProductEvent.fetchAllFromState());
              }
            },
          ),
          const SpaceHeight(16.0),
          ValueListenableBuilder(
            valueListenable: indexValue,
            builder: (context, value, _) => Row(
              children: [
                MenuButton(
                  iconPath: Assets.icons.allCategories.path,
                  label: 'All',
                  isActive: value == 0,
                  onPressed: () => onCategoryTap(0),
                ),
                const SpaceWidth(10.0),
                MenuButton(
                  iconPath: Assets.icons.drink.path,
                  label: 'Drink',
                  isActive: value == 1,
                  onPressed: () => onCategoryTap(1),
                ),
                const SpaceWidth(10.0),
                MenuButton(
                  iconPath: Assets.icons.food.path,
                  label: 'Food',
                  isActive: value == 2,
                  onPressed: () => onCategoryTap(2),
                ),
                const SpaceWidth(10.0),
                MenuButton(
                  iconPath: Assets.icons.snack.path,
                  label: 'Snack',
                  isActive: value == 3,
                  onPressed: () => onCategoryTap(3),
                ),
              ],
            ),
          ),
          const SpaceHeight(16.0),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return const SizedBox();
              }, loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }, error: (message) {
                return Center(
                  child: Text(message),
                );
              }, success: (products) {
                if (products.isEmpty) return const ProductEmpty();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.75,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemBuilder: (context, index) => ProductCard(
                    data: products[index],
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
