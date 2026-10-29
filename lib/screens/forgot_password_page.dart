import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum _RecoveryMethod { email, phone }

enum _RecoveryStep { chooseMethod, verifyCode, newPassword }

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  _RecoveryMethod _method = _RecoveryMethod.email;
  _RecoveryStep _step = _RecoveryStep.chooseMethod;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _destinationController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitRecoveryMethod() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _step = _RecoveryStep.verifyCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _method == _RecoveryMethod.email
              ? 'Reset instructions are ready to be sent by email.'
              : 'A verification code is ready to be sent by SMS.',
        ),
      ),
    );
  }

  void _verifyCode() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _step = _RecoveryStep.newPassword);
  }

  void _savePassword() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Password reset is ready to connect to an account service.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (_step) {
      _RecoveryStep.chooseMethod => 'Forgot Password',
      _RecoveryStep.verifyCode => 'Enter the OTP',
      _RecoveryStep.newPassword => 'Reset Password',
    };
    final description = switch (_step) {
      _RecoveryStep.chooseMethod =>
        'Choose where you would like to receive your reset code',
      _RecoveryStep.verifyCode =>
        'Enter the 6-digit code sent to your ${_method == _RecoveryMethod.email ? 'email' : 'phone'}',
      _RecoveryStep.newPassword => 'Create a new password for your account',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF171B2A),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.primary.withOpacity(0.68),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 28),
                if (_step == _RecoveryStep.chooseMethod) ...[
                  _MethodChoice(
                    title: 'E-mail address',
                    subtitle: 'Receive a password reset link',
                    icon: Icons.alternate_email,
                    selected: _method == _RecoveryMethod.email,
                    onTap: () =>
                        setState(() => _method = _RecoveryMethod.email),
                  ),
                  const SizedBox(height: 12),
                  _MethodChoice(
                    title: 'Phone number',
                    subtitle: 'Receive a verification code by SMS',
                    icon: Icons.phone_rounded,
                    selected: _method == _RecoveryMethod.phone,
                    onTap: () =>
                        setState(() => _method = _RecoveryMethod.phone),
                  ),
                  const SizedBox(height: 22),
                  _RecoveryInput(
                    controller: _destinationController,
                    label: _method == _RecoveryMethod.email
                        ? 'E-mail address'
                        : 'Phone number',
                    icon: _method == _RecoveryMethod.email
                        ? Icons.alternate_email
                        : Icons.phone_rounded,
                    keyboardType: _method == _RecoveryMethod.email
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return _method == _RecoveryMethod.email
                            ? 'Enter your email address'
                            : 'Enter your phone number';
                      }
                      if (_method == _RecoveryMethod.email &&
                          !value.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ] else if (_step == _RecoveryStep.verifyCode) ...[
                  _RecoveryInput(
                    controller: _codeController,
                    label: '6-digit verification code',
                    icon: Icons.pin_rounded,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.trim().length != 6
                            ? 'Enter the 6-digit code'
                            : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          setState(() => _step = _RecoveryStep.chooseMethod),
                      child: const Text('Change delivery method'),
                    ),
                  ),
                ] else ...[
                  _RecoveryInput(
                    controller: _passwordController,
                    label: 'New password',
                    icon: Icons.key_rounded,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                    validator: (value) => value == null || value.length < 8
                        ? 'Use at least 8 characters'
                        : null,
                  ),
                ],
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: switch (_step) {
                      _RecoveryStep.chooseMethod => _submitRecoveryMethod,
                      _RecoveryStep.verifyCode => _verifyCode,
                      _RecoveryStep.newPassword => _savePassword,
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: AppColors.primary.withOpacity(0.18),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      switch (_step) {
                        _RecoveryStep.chooseMethod =>
                          _method == _RecoveryMethod.email
                              ? 'Send Reset Link'
                              : 'Send OTP',
                        _RecoveryStep.verifyCode => 'Verify OTP',
                        _RecoveryStep.newPassword => 'Change Password',
                      },
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                    child: const Text('Back to Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MethodChoice extends StatelessWidget {
  const _MethodChoice({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.button.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.button : const Color(0xFFE7E7E7),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.primary.withOpacity(0.68),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: AppColors.button,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoveryInput extends StatelessWidget {
  const _RecoveryInput({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFE7E7E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFE7E7E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.button, width: 1.5),
        ),
      ),
    );
  }
}
