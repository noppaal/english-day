import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_button.dart';

/// Scaffold standar: app bar (back + judul + aksi) dan area aksi bawah
/// yang dipisah garis tipis, sesuai pola semua layar desain.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.bottom,
    this.leadingIcon = Icons.arrow_back,
    this.onBack,
    this.showBack = true,
    this.action,
  });

  final String? title;
  final Widget body;
  final Widget? bottom;
  final IconData leadingIcon;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null && !showBack
          ? null
          : AppBar(
              toolbarHeight: 64,
              automaticallyImplyLeading: false,
              titleSpacing: showBack ? 0 : 20,
              leading: showBack
                  ? IconButton(
                      onPressed: onBack ?? () => Navigator.maybePop(context),
                      icon: Icon(leadingIcon, color: AppColors.primary),
                    )
                  : null,
              title: title != null ? Text(title!) : null,
              actions: [
                if (action != null) action!,
                const SizedBox(width: 12),
              ],
            ),
      body: SafeArea(top: false, bottom: bottom == null, child: body),
      bottomNavigationBar: bottom == null ? null : BottomActionBar(child: bottom!),
    );
  }
}

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: child,
        ),
      ),
    );
  }
}

/// Kartu putih ber-border.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

enum BannerType { warning, error }

/// Banner status AI / koneksi (Masih memproses / AI belum merespons).
class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.type,
    required this.message,
    required this.actionLabel,
    this.onAction,
  });

  const StatusBanner.slow({super.key, this.onAction})
      : type = BannerType.warning,
        message = 'Masih memproses. Kamu bisa menunggu atau batalkan.',
        actionLabel = 'Batalkan';

  const StatusBanner.timeout({super.key, this.onAction})
      : type = BannerType.error,
        message = 'AI belum merespons. Coba lagi dalam beberapa saat.',
        actionLabel = 'Coba lagi';

  final BannerType type;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final color = type == BannerType.warning ? AppColors.warning : AppColors.error;
    final icon = type == BannerType.warning ? Icons.schedule : Icons.error_outline;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: AppText.sans(
                        size: 15, weight: FontWeight.w600, color: color, height: 1.35)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: AppTextAction(label: actionLabel, onPressed: onAction),
          ),
        ],
      ),
    );
  }
}

/// Garis skeleton untuk state loading.
class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({super.key, this.width, this.height = 12, this.radius = 6});
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return _Pulse(
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.skeleton,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Kumpulan garis skeleton paragraf.
class SkeletonParagraph extends StatelessWidget {
  const SkeletonParagraph({super.key, this.groups = 3, this.withTitle = true});
  final int groups;
  final bool withTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (withTitle) ...[
            SkeletonBlock(width: c.maxWidth * 0.68, height: 24),
            const SizedBox(height: 24),
          ],
          for (var g = 0; g < groups; g++) ...[
            const SkeletonBlock(),
            const SizedBox(height: 16),
            const SkeletonBlock(),
            const SizedBox(height: 16),
            SkeletonBlock(width: c.maxWidth * 0.62),
            const SizedBox(height: 16),
          ],
        ],
      );
    });
  }
}

class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});
  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.55, end: 1.0).animate(_c),
      child: widget.child,
    );
  }
}

/// Lingkaran ikon besar untuk halaman informasi (offline, izin mic).
class CircleIllustration extends StatelessWidget {
  const CircleIllustration({super.key, required this.icon, this.size = 96});
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE6ECF7),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: size * 0.36),
    );
  }
}

/// Halaman informasi: ilustrasi + judul + deskripsi.
class InfoStateView extends StatelessWidget {
  const InfoStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.circleSize = 96,
  });

  final IconData icon;
  final String title;
  final String message;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleIllustration(icon: icon, size: circleSize),
          const SizedBox(height: 28),
          Text(title, style: AppText.h2),
          const SizedBox(height: 20),
          Text(message, style: AppText.body),
        ],
      ),
    );
  }
}

/// Label meta kecil, mis. "Medium · Budaya".
class MetaLabel extends StatelessWidget {
  const MetaLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: AppText.sans(size: 14, weight: FontWeight.w500, color: AppColors.textSecondary));
  }
}

/// Skor besar dengan latar stabilo kuning.
class ScoreBadge extends StatelessWidget {
  const ScoreBadge(this.score, {super.key});
  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: AppColors.highlight,
      child: Text(score, style: AppText.sans(size: 30, weight: FontWeight.w800)),
    );
  }
}

/// Snackbar gaya desain ("Teks disalin.").
void showAppSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      content: Row(
        children: [
          const Icon(Icons.check, color: Colors.white),
          const SizedBox(width: 16),
          Text(message, style: AppText.sans(size: 15, weight: FontWeight.w500, color: Colors.white)),
        ],
      ),
    ));
}

