import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter a password';
    if (v.length < 8) return 'At least 8 characters required';
    if (!v.contains(RegExp(r'[A-Za-z]'))) {
      return 'Must contain letters';
    }
    if (!v.contains(RegExp(r'[0-9]'))) {
      return 'Must contain numbers';
    }
    if (!v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]'))) {
      return 'Must contain a special character e.g. !@#\$';
    }
    return null;
  }

  Future<void> _register() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final error = await context.read<UserProvider>().register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      // Show success then go to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created! Please sign in to continue.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create account ✨',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Join MarketFresh for fresh groceries delivered fast',
                  style: TextStyle(
                      fontSize: 15, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Error banner
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                          color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 18),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(_errorMessage!,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.error)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Password hint box
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Password requirements:',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                      SizedBox(height: 4),
                      Text(
                        '• At least 8 characters\n'
                        '• Letters (A-Z or a-z)\n'
                        '• Numbers (0-9)\n'
                        '• Special character e.g. !@#\$%',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryDark,
                            height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Full name
                const _FieldLabel(label: 'Full name'),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'John Kamau',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your full name'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // Email
                const _FieldLabel(label: 'Email address'),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'you@example.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$')
                        .hasMatch(v.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Phone
                const _FieldLabel(label: 'Phone number (M-Pesa)'),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: '0712 345 678',
                    prefixIcon: Icon(Icons.phone_outlined),
                    helperText:
                        'Used for M-Pesa payments',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    final digits = v.replaceAll(RegExp(r'\D'), '');
                    if (digits.length < 9 || digits.length > 12) {
                      return 'Enter a valid Kenyan phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Password
                const _FieldLabel(label: 'Password'),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'e.g. Kamau@2024',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                      child: Icon(_obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: AppSpacing.md),

                // Confirm password
                const _FieldLabel(label: 'Confirm password'),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _register(),
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                          () => _obscureConfirm = !_obscureConfirm),
                      child: Icon(_obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (v != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.textOnPrimary),
                        )
                      : const Text('Create account'),
                ),
                const SizedBox(height: AppSpacing.lg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Sign in',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary));
  }
}