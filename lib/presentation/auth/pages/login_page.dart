import 'package:fic12_fe/core/assets/assets.gen.dart';
import 'package:fic12_fe/core/components/buttons.dart';
import 'package:fic12_fe/core/components/custom_text_field.dart';
import 'package:fic12_fe/core/components/spaces.dart';
import 'package:fic12_fe/data/data_resources/auth_local_data_source.dart';
import 'package:fic12_fe/data/models/request/auth_request_model.dart';
import 'package:fic12_fe/presentation/auth/bloc/login/login_bloc.dart';
import 'package:fic12_fe/presentation/home/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SpaceHeight(80.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 130.0),
            child: Image.asset(
              Assets.images.logo.path,
              width: 100,
              height: 100,
            ),
          ),
          const SpaceHeight(24.0),
          const Center(
            child: Text(
              "POS Batch 12",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SpaceHeight(8.0),
          const Center(
            child: Text(
              'Login to your account',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          const SpaceHeight(40.0),
          CustomTextField(
            controller: usernameController,
            label: 'Email',
          ),
          const SpaceHeight(12.0),
          CustomTextField(
            controller: passwordController,
            label: 'Password',
            obscureText: true,
          ),
          const SpaceHeight(24.0),
          BlocConsumer<LoginBloc, LoginState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => Button.filled(
                  onPressed: () {
                    final input = AuthRequestModel(
                      email: usernameController.text,
                      password: passwordController.text,
                    );
                    context
                        .read<LoginBloc>()
                        .add(LoginEvent.login(authRequestModel: input));
                  },
                  label: 'Login',
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: (authResponseModel) {
                  AuthLocalDataSource().saveAuthData(authResponseModel);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ),
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
