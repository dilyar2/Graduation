import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/app_router.dart';
import 'package:graduation2/core/utils/validators.dart';
import 'package:graduation2/core/di/injection.dart';
import 'package:graduation2/core/storage/token_storage.dart';
import 'package:graduation2/Features/authentication/data/models/login_request_model.dart';
import 'package:graduation2/Features/authentication/presentation/pages/manager/bloc/auth_bloc.dart';
import 'package:graduation2/Features/authentication/presentation/widgets/custom_elevated_button.dart';
import 'package:graduation2/Features/authentication/presentation/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _redirectIfSessionExists();
  }

  Future<void> _redirectIfSessionExists() async {
    final hasSession = await getIt<TokenStorage>().hasSession();
    if (!mounted || !hasSession) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.home,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginRequestedEvent(
          request: LoginRequestModel(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is Authenticated) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset("assets/img/logo.png"),
                    CustomTextField(
                      label: "Email",
                      textEditingController: _emailController,
                      obsecure: false,
                      textInputType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_rounded),
                      validator: Validators.email,
                    ),

                    CustomTextField(
                      label: "Password",
                      textEditingController: _passwordController,
                      obsecure: true,
                      textInputType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.lock),
                      validator: (v) => Validators.password(v),
                    ),
                    CustomElevatedButton(onPressed: _submit, text: "Login",height: 50,width: 100,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: Theme.of(context).textTheme.bodyMedium),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRouter.signup),
                          child: Text(
                            "Sign up",
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
