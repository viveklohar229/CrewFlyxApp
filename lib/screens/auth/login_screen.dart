import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../state/app_state_provider.dart';
import '../../widgets/aviation_logo.dart';
import '../../widgets/aviation_button.dart';
import '../../widgets/aviation_text_field.dart';

/// Modern aviation Login screen with validation, show/hide password, and mock authentication.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'captain.hayes');
  final _passwordController = TextEditingController(text: 'flyx2026');
  final _companyCodeController = TextEditingController(text: 'SKY-AERO');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _companyCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(AppStrings.loginErrorEmpty),
          backgroundColor: AppColors.emergencyRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final state = AppStateScope.of(context);
    final success = await state.login(
      username: _usernameController.text,
      password: _passwordController.text,
      companyCode: _companyCodeController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.authError ?? 'Login failed. Please check your credentials.'),
          backgroundColor: AppColors.emergencyRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = AppStateScope.of(context);
    final isLoading = state.isLoggingIn;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top Logo & Brand Header
                    const AviationLogo(size: 72),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.loginTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        color: isDark ? Colors.white : AppColors.aeroNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Card Container for Form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primarySky.withValues(alpha: isDark ? 0.08 : 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Username
                          AviationTextField(
                            controller: _usernameController,
                            label: AppStrings.usernameLabel,
                            hint: AppStrings.usernameHint,
                            prefixIcon: Icons.person_outline,
                            validator: Validators.validateUsername,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 18),

                          // 2. Password
                          AviationTextField(
                            controller: _passwordController,
                            label: AppStrings.passwordLabel,
                            hint: AppStrings.passwordHint,
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            validator: Validators.validatePassword,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 18),

                          // 3. Company Code
                          AviationTextField(
                            controller: _companyCodeController,
                            label: AppStrings.companyCodeLabel,
                            hint: AppStrings.companyCodeHint,
                            prefixIcon: Icons.business_outlined,
                            textCapitalization: TextCapitalization.characters,
                            validator: Validators.validateCompanyCode,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _handleLogin(),
                          ),
                          const SizedBox(height: 28),

                          // 4. Large Login Button
                          AviationButton(
                            text: AppStrings.loginButton,
                            isLoading: isLoading,
                            icon: Icons.flight_takeoff,
                            onPressed: _handleLogin,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Demo Credentials Helper Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primarySky.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primarySky.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline, size: 14, color: AppColors.primarySky),
                          SizedBox(width: 6),
                          Text(
                            AppStrings.demoCredentialsHint,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primarySkyDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
