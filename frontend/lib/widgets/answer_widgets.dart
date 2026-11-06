import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum OptionState { normal, selected, correct, wrong }

/// Pilihan jawaban sesuai "Komponen · jawaban dan percakapan".
class AnswerOption extends StatelessWidget {
  const AnswerOption({
    super.key,
    required this.label,
    this.state = OptionState.normal,
    this.onTap,
  });

  final String label;
  final OptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    late Color border;
    late Color bg;
    late Widget icon;
    double borderWidth = 2;

    switch (state) {
      case OptionState.normal:
        border = AppColors.border;
        bg = AppColors.surface;
        borderWidth = 1;
        icon = _ring(AppColors.textPrimary);
      case OptionState.selected:
        border = AppColors.primary;
        bg = AppColors.primarySoft;
        icon = _ring(AppColors.primary,
            inner: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ));
      case OptionState.correct:
        border = AppColors.success;
        bg = AppColors.surface;
        icon = _ring(AppColors.success,
            inner: const Icon(Icons.check, size: 13, color: AppColors.success));
      case OptionState.wrong:
        border = AppColors.error;
        bg = AppColors.surface;
        icon = _ring(AppColors.error,
            inner: const Icon(Icons.close, size: 13, color: AppColors.error));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: border, width: borderWidth),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                      style: AppText.sans(
                          size: 16,
                          color: state == OptionState.selected
                              ? AppColors.textPrimary
                              : AppColors.textPrimary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ring(Color color, {Widget? inner}) => Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.4),
        ),
        alignment: Alignment.center,
        child: inner,
      );
}

/// Umpan balik Benar / Belum tepat.
class AnswerFeedback extends StatelessWidget {
  const AnswerFeedback({super.key, required this.correct, required this.message});
  final bool correct;
  final String message;

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.success : AppColors.error;
    return Padding(
      padding: const EdgeInsets.only(left: 2, top: 4, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.4),
            ),
            child: Icon(correct ? Icons.check : Icons.close, size: 13, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(correct ? 'Benar' : 'Belum tepat',
                    style: AppText.sans(size: 15, weight: FontWeight.w700, color: color)),
                const SizedBox(height: 4),
                Text(message,
                    style: AppText.sans(
                        size: 14,
                        weight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Gelembung percakapan Speaking.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.text,
    required this.fromAi,
    this.speaking = false,
    this.onSpeaker,
  });

  final String text;
  final bool fromAi;
  final bool speaking;
  final VoidCallback? onSpeaker;

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.sizeOf(context).width * 0.8;
    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxW),
      padding: EdgeInsets.fromLTRB(12, 12, fromAi ? 6 : 12, 12),
      decoration: BoxDecoration(
        color: fromAi ? AppColors.surface : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
        border: fromAi ? Border.all(color: AppColors.border) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(text,
                style: AppText.sans(
                  size: 16,
                  height: 1.5,
                  color: fromAi ? AppColors.textPrimary : AppColors.primary,
                )),
          ),
          if (fromAi) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 44,
              height: 44,
              child: speaking
                  ? const Center(child: SoundWave(bars: 5, height: 18))
                  : IconButton(
                      onPressed: onSpeaker,
                      icon: const Icon(Icons.volume_up_outlined,
                          color: AppColors.primary, size: 22),
                    ),
            ),
          ],
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: fromAi ? Alignment.centerLeft : Alignment.centerRight,
        child: bubble,
      ),
    );
  }
}

/// Visual gelombang suara beranimasi.
class SoundWave extends StatefulWidget {
  const SoundWave({super.key, this.bars = 9, this.height = 26, this.color = AppColors.primary});
  final int bars;
  final double height;
  final Color color;

  @override
  State<SoundWave> createState() => _SoundWaveState();
}

class _SoundWaveState extends State<SoundWave> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pattern = [0.35, 0.6, 0.85, 0.5, 1.0, 0.7, 0.45, 0.8, 0.4];
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.bars, (i) {
            final base = pattern[i % pattern.length];
            final t = (_c.value + i / widget.bars) % 1.0;
            final f = 0.6 + 0.4 * (1 - (2 * t - 1).abs());
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 3,
              height: widget.height * base * f,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}

