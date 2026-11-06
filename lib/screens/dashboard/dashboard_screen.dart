import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/common.dart';
import '../auth/auth_screens.dart';
import '../listening/listening_screen.dart';
import '../profile/profile_screen.dart';
import '../reading/reading_screens.dart';
import '../speaking/speaking_screens.dart';
import '../writing/writing_screens.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    this.hasProgress = true,
    this.showSessionExpired = false,
  });

  final bool hasProgress;
  final bool showSessionExpired;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.showSessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showSessionExpiredSheet(context));
    }
  }

  void _push(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo, ${DummyUser.firstName}', style: AppText.display),
                      const SizedBox(height: 4),
                      Text('Mau latihan apa hari ini?',
                          style: AppText.body.copyWith(fontSize: 17)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Material(
                    color: AppColors.primarySoft,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _push(const ProfileScreen()),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: Text(DummyUser.initials,
                              style: AppText.sans(
                                  size: 15, weight: FontWeight.w700, color: AppColors.primary)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (widget.hasProgress) ...[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lanjutkan latihan',
                        style: AppText.sans(
                            size: 15, weight: FontWeight.w500, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Text('Reading · ${ReadingDummy.storyTitle}',
                        style: AppText.sans(size: 19, weight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    AppButton.secondary(
                      label: 'Lanjutkan',
                      onPressed: () => _push(const ReadingStoryScreen()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
            Text('Latihan', style: AppText.h3),
            const SizedBox(height: 12),
            _MenuTile(
              icon: Icons.edit_outlined,
              iconColor: AppColors.primary,
              bg: AppColors.writingBg,
              title: 'Writing',
              subtitle: 'Tulis kalimat, AI tandai yang perlu diperbaiki',
              onTap: () => _push(const WritingInputScreen()),
            ),
            _MenuTile(
              icon: Icons.menu_book_outlined,
              iconColor: AppColors.readingIcon,
              bg: AppColors.readingBg,
              title: 'Reading',
              subtitle: 'Baca cerita pendek, lalu jawab kuis',
              onTap: () => _push(const ReadingSettingsScreen()),
            ),
            _MenuTile(
              icon: Icons.mic_none_rounded,
              iconColor: AppColors.speakingIcon,
              bg: AppColors.speakingBg,
              title: 'Speaking',
              subtitle: 'Ngobrol langsung dengan AI pakai suara',
              onTap: () => _push(const MicPermissionScreen()),
            ),
            _MenuTile(
              icon: Icons.headphones_outlined,
              iconColor: AppColors.listeningIcon,
              bg: AppColors.listeningBg,
              title: 'Listening',
              subtitle: 'Dengarkan audio, lalu jawab pertanyaan',
              onTap: () => _push(const ListeningScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.bg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color bg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.sans(size: 16, weight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: AppText.sans(size: 13, color: AppColors.textSecondary, height: 1.35)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet "Sesimu sudah berakhir".
Future<void> showSessionExpiredSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sesimu sudah berakhir.\nMasuk lagi untuk melanjutkan.',
              style: AppText.sans(size: 21, weight: FontWeight.w600, height: 1.4)),
          const SizedBox(height: 20),
          AppButton(
            label: 'Masuk',
            onPressed: () => Navigator.of(ctx).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false,
            ),
          ),
        ],
      ),
    ),
  );
}

