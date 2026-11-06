import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/common.dart';
import '../auth/auth_screens.dart';
import '../gallery/gallery_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.showLogoutConfirm = false});
  final bool showLogoutConfirm;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.showLogoutConfirm) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _confirmLogout());
    }
  }

  void _confirmLogout() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Keluar dari akun?', style: AppText.h2),
            const SizedBox(height: 16),
            Text('Kamu perlu masuk lagi untuk melanjutkan latihan.', style: AppText.body),
            const SizedBox(height: 24),
            AppButton.danger(
              label: 'Keluar',
              onPressed: () => Navigator.of(ctx).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              ),
            ),
            const SizedBox(height: 24),
            AppButton.secondary(label: 'Batal', onPressed: () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profil',
      bottom: AppButton.danger(label: 'Keluar', onPressed: _confirmLogout),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(DummyUser.initials,
                  style: AppText.sans(size: 22, weight: FontWeight.w700, color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 16),
          Text(DummyUser.name, style: AppText.h2),
          const SizedBox(height: 12),
          Text(DummyUser.email, style: AppText.body),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary),
              ),
              child: Text(DummyUser.role,
                  style: AppText.sans(size: 15, weight: FontWeight.w600, color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 24),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _ProfileItem(
                  icon: Icons.person_outline,
                  label: 'Ubah nama',
                  onTap: () => showAppSnack(context, 'Fitur ubah nama (dummy).'),
                ),
                _ProfileItem(
                  icon: Icons.lock_outline,
                  label: 'Ubah password',
                  onTap: () => showAppSnack(context, 'Fitur ubah password (dummy).'),
                ),
                _ProfileItem(
                  icon: Icons.info_outline,
                  label: 'Tentang aplikasi',
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const GalleryScreen())),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('${AppInfo.tagline}\nVersi ${AppInfo.version}', style: AppText.small),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(child: Text(label, style: AppText.sans(size: 15, weight: FontWeight.w600))),
              const Icon(Icons.chevron_right, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

