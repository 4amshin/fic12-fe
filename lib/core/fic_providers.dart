import 'package:fic12_fe/data/data_resources/auth_remote_data_source.dart';
import 'package:fic12_fe/data/data_resources/product_remote_data_source.dart';
import 'package:fic12_fe/presentation/auth/bloc/login/login_bloc.dart';
import 'package:fic12_fe/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:fic12_fe/presentation/home/bloc/logout/logout_bloc.dart';
import 'package:fic12_fe/presentation/home/bloc/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FicProviders extends StatelessWidget {
  final Widget child;
  const FicProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
      ],
      child: child,
    );
  }
}
