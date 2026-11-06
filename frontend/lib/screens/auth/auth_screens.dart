import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/common.dart';
import '../dashboard/dashboard_screen.dart';

// ------------------------------------------------------------------ Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.autoNavigate = true});
  final bool autoNavigate;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoNavigate) {
      _timer = Timer(const Duration(milliseconds: 1800), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppInfo.appName, style: AppText.display),
            const SizedBox(height: 16),
            Container(width: 72, height: 2, color: AppColors.border),
            const SizedBox(height: 16),
            Text(AppInfo.tagline, style: AppText.sans(size: 14, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------- Login
enum LoginState { idle, loading, error }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.initialState = LoginState.idle});
  final LoginState initialState;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginState _state = widget.initialState;
  late final _email = TextEditingController(
      text: widget.initialState == LoginState.idle ? '' : DummyUser.email);
  late final _password = TextEditingController(
      text: widget.initialState == LoginState.idle ? '' : 'salah123');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _state = LoginState.loading);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    // Dummy auth: email valid + password minimal 8 karakter dan bukan "salah123".
    final ok = _email.text.contains('@') &&
        _password.text.length >= 8 &&
        _password.text != 'salah123';
    if (ok) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (_) => false,
      );
    } else {
      setState(() => _state = LoginState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = _state == LoginState.loading;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppInfo.tagline,
                  style: AppText.sans(size: 14, weight: FontWeight.w600, color: AppColors.primary)),
              const SizedBox(height: 28),
              Text('Masuk', style: AppText.h1),
              const SizedBox(height: 8),
              Text('Lanjutkan latihan bahasa Inggrismu.', style: AppText.body.copyWith(fontSize: 17)),
              const SizedBox(height: 24),
              if (_state == LoginState.error) ...[
                StatusBanner(
                  type: BannerType.error,
                  message: 'Email atau password salah.',
                  actionLabel: 'Coba lagi',
                  onAction: () => setState(() {
                    _state = LoginState.idle;
                    _password.clear();
                  }),
                ),
                const SizedBox(height: 24),
              ],
              AppTextField(
                label: 'Email',
                hint: 'nama@email.com',
                controller: _email,
                enabled: !loading,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: 'Password',
                hint: 'Masukkan password',
                controller: _password,
                enabled: !loading,
                obscure: true,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: AppTextAction(
                  label: 'Lupa password?',
                  onPressed: () => showAppSnack(context, 'Link reset dikirim ke email kamu.'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              label: 'Masuk',
              loading: loading,
              loadingLabel: 'Masuk…',
              onPressed: _submit,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum punya akun? ',
                    style: AppText.sans(size: 15, color: AppColors.textSecondary)),
                AppTextAction(
                  label: 'Daftar',
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Register
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.showErrors = false});
  final bool showErrors;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  late final _email = TextEditingController(text: widget.showErrors ? 'rina.amelia@' : '');
  late final _password = TextEditingController(text: widget.showErrors ? '123456' : '');
  late final _confirm = TextEditingController(text: widget.showErrors ? '123456789' : '');
  String _role = 'Siswa';
  bool _loading = false;
  Map<String, String?> _errors = {};

  @override
  void initState() {
    super.initState();
    if (widget.showErrors) _errors = _validate();
  }

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, String?> _validate() {
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_email.text);
    return {
      'name': _name.text.trim().isEmpty ? 'Nama lengkap wajib diisi.' : null,
      'email': emailOk ? null : 'Masukkan email yang valid.',
      'password': _password.text.length < 8 ? 'Password minimal 8 karakter.' : null,
      'confirm': _confirm.text != _password.text || _confirm.text.isEmpty
          ? 'Konfirmasi password tidak sama.'
          : null,
    };
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final errors = _validate();
    setState(() => _errors = errors);
    if (errors.values.any((e) => e != null)) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen(hasProgress: false)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Buat akun',
      bottom: AppButton(
        label: 'Daftar',
        loading: _loading,
        loadingLabel: 'Mendaftar…',
        onPressed: _submit,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Nama lengkap',
              hint: 'Nama lengkap kamu',
              controller: _name,
              errorText: _errors['name'],
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Email',
              hint: 'nama@email.com',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              errorText: _errors['email'],
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Password',
              hint: 'Masukkan password',
              controller: _password,
              obscure: true,
              errorText: _errors['password'],
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Konfirmasi password',
              hint: 'Ulangi password',
              controller: _confirm,
              obscure: true,
              errorText: _errors['confirm'],
            ),
            const SizedBox(height: 16),
            Text('Kamu sebagai', style: AppText.label),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final r in ['Siswa', 'Guru'])
                  AppChoiceChip(
                    label: r,
                    selected: _role == r,
                    onTap: () => setState(() => _role = r),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

