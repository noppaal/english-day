import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum AppButtonVariant { primary, secondary, danger }

/// Tombol utama 52dp sesuai desain "Komponen · tombol".
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.loadingLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final String? loadingLabel;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.loadingLabel,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.loadingLabel,
  }) : variant = AppButtonVariant.danger;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null && !widget.loading;

    Color bg;
    Color fg;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        bg = _pressed ? AppColors.primaryPressed : AppColors.primary;
        fg = Colors.white;
      case AppButtonVariant.secondary:
        bg = _pressed ? AppColors.border : AppColors.primarySoft;
        fg = AppColors.primary;
      case AppButtonVariant.danger:
        bg = _pressed ? const Color(0xFFD9625C) : AppColors.error;
        fg = Colors.white;
    }
    if (disabled) {
      bg = AppColors.disabled;
      fg = AppColors.disabledText;
    }

    final content = widget.loading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              ),
              const SizedBox(width: 12),
              Text(widget.loadingLabel ?? widget.label,
                  style: AppText.sans(size: 17, weight: FontWeight.w600, color: fg)),
            ],
          )
        : Text(widget.label,
            style: AppText.sans(size: 15, weight: FontWeight.w600, color: fg));

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null && !widget.loading) setState(() => _pressed = true);
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.loading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: content,
      ),
    );
  }
}

/// Aksi teks (target sentuh 48dp).
class AppTextAction extends StatelessWidget {
  const AppTextAction({super.key, required this.label, this.onPressed, this.color});

  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: AppText.sans(
                size: 15,
                weight: FontWeight.w700,
                color: color ?? AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

