import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/app_router.dart';
import 'package:graduation2/core/utils/validators.dart';
import 'package:graduation2/Features/authentication/data/models/register_request_model.dart';
import 'package:graduation2/Features/authentication/presentation/pages/manager/bloc/auth_bloc.dart';
import 'package:graduation2/Features/authentication/presentation/widgets/custom_elevated_button.dart';
import 'package:graduation2/Features/authentication/presentation/widgets/custom_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterRequestedEvent(
              request: RegisterRequestModel(
                email: _emailController.text.trim(),
                password: _passwordController.text,
                firstName: _firstNameController.text.trim(),
                lastName: _lastNameController.text.trim(),
                phoneNumber: _phoneController.text.trim(),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Account created successfully. Signing you in...',
                ),
              ),
            );
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
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                    Image.asset("assets/img/logo.png"),
                  CustomTextField(
                    label: "First name",
                    textEditingController: _firstNameController,
                    obsecure: false,
                    textInputType: TextInputType.name,
                    prefixIcon: const Icon(Icons.person),
                    validator: (v) => Validators.required(v, 'First name'),
                  ),
                  CustomTextField(
                    label: "Last name",
                    textEditingController: _lastNameController,
                    obsecure: false,
                    textInputType: TextInputType.name,
                    prefixIcon: const Icon(Icons.person),
                    validator: (v) => Validators.required(v, 'Last name'),
                  ),
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
                  CustomTextField(
                    label: "Phone",
                    textEditingController: _phoneController,
                    obsecure: false,
                    textInputType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone),
                    validator: Validators.phone,
                  ),
                  CustomElevatedButton(
                    onPressed: _submit,
                    text: "Sign up",
                    height: 50,
                    width: 120,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed(AppRouter.login),
                        child: Text("Login",
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            )) ,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
