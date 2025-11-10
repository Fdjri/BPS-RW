import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../blocs/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: AppColors.blue.light,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.success) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
                arguments: state.username,
              );
            } else if (state.status == LoginStatus.failure) {
              showDialog(
                context: context,
                barrierDismissible: true, 
                builder: (BuildContext dialogContext) { 
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: AppColors.white.normal,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Widget Lottie
                          Lottie.asset(
                            'assets/lottie/error.json',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Gagal Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'InstrumentSans',
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: AppColors.black.normal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage ?? 'Terjadi kesalahan. Coba lagi.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'InstrumentSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppColors.white.darker,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == LoginStatus.loading;

            return SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        color: AppColors.blue.lightActive,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(80),
                          bottomRight: Radius.circular(80),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.35,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 50), 
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/images/logo_bps.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                'Bidang Pengelola Sampah RW',
                                textAlign: TextAlign.center, 
                                style: TextStyle(
                                  fontFamily: 'InstrumentSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22, 
                                  color: AppColors.black.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white.normal,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.normal.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _usernameController,
                                style: const TextStyle(fontFamily: 'InstrumentSans'),
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                    fontFamily: 'InstrumentSans',
                                    color: AppColors.white.dark,
                                    fontSize: 16,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white.normal,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: AppColors.white.darkActive),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: AppColors.black.light),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController, 
                                style: const TextStyle(fontFamily: 'InstrumentSans'),
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    fontFamily: 'InstrumentSans',
                                    color: AppColors.white.dark,
                                    fontSize: 16,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white.normal,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: AppColors.white.darkActive),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: AppColors.black.light),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible 
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                      color: AppColors.white.darkActive,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Lupa Password?',
                                  style: TextStyle(
                                    fontFamily: 'InstrumentSans',
                                    color: AppColors.white.darker,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: isLoading 
                                      ? null
                                      : () {
                                          context.read<LoginCubit>().login(
                                                _usernameController.text,
                                                _passwordController.text,
                                              );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue.normal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontFamily: 'InstrumentSans',
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}