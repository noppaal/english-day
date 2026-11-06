import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Input teks sesuai "Komponen · input dan pilihan".
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.obscure = false,
    this.enabled = true,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscure;
  final bool enabled;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  OutlineInputBorder _border(Color color, [double width = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppText.label),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: _hidden,
          obscuringCharacter: '•',
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          style: AppText.sans(
            size: 17,
            color: widget.enabled ? AppColors.primary : AppColors.textMuted,
            weight: _hidden ? FontWeight.w700 : FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppText.sans(size: 17, color: AppColors.textMuted),
            filled: true,
            fillColor: widget.enabled ? AppColors.surface : AppColors.disabled,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            enabledBorder: _border(hasError ? AppColors.error : AppColors.border),
            focusedBorder: _border(hasError ? AppColors.error : AppColors.primary, 2),
            disabledBorder: _border(AppColors.disabled),
            suffixIcon: widget.obscure
                ? IconButton(
                    onPressed: () => setState(() => _hidden = !_hidden),
                    icon: Icon(
                      _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          FieldError(widget.errorText!),
        ],
      ],
    );
  }
}

class FieldError extends StatelessWidget {
  const FieldError(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, size: 18, color: AppColors.error),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message,
              style: AppText.sans(size: 14, color: AppColors.error, weight: FontWeight.w500)),
        ),
      ],
    );
  }
}

/// Chip pilihan (Siswa/Guru, topik, dsb).
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = subtitle != null ? 14.0 : 24.0;
    return Material(
      color: selected ? AppColors.primarySoft : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 72),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: subtitle != null ? 12 : 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: AppText.sans(
                    size: 15,
                    weight: FontWeight.w600,
                    color: selected ? AppColors.primary : AppColors.textPrimary,
                  )),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!,
                    style: AppText.sans(
                      size: 13,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

