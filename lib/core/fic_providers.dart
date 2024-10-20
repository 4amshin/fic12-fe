import 'package:fic12_fe/data/data_resources/auth_remote_data_source.dart';
import 'package:fic12_fe/presentation/auth/bloc/login/login_bloc.dart';
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
        )
      ],
      child: child,
    );
  }
}
