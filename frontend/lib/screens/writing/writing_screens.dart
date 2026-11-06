import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/common.dart';
import '../../widgets/lined_paper.dart';

enum WritingState { idle, loading, slow, error }

// ------------------------------------------------------------ Input screen
class WritingInputScreen extends StatefulWidget {
  const WritingInputScreen({
    super.key,
    this.initialText = '',
    this.initialState = WritingState.idle,
  });

  final String initialText;
  final WritingState initialState;

  @override
  State<WritingInputScreen> createState() => _WritingInputScreenState();
}

class _WritingInputScreenState extends State<WritingInputScreen> {
  late final _controller = TextEditingController(text: widget.initialText);
  late WritingState _state = widget.initialState;
  Timer? _slowTimer;
  Timer? _doneTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    _doneTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  int get _count => _controller.text.length;
  bool get _overLimit => _count > WritingDummy.maxChars;
  bool get _busy => _state == WritingState.loading || _state == WritingState.slow;

  void _check() {
    FocusScope.of(context).unfocus();
    setState(() => _state = WritingState.loading);
    // Simulasi: banner "masih memproses" muncul setelah 10 detik,
    // respons dummy datang setelah 2.5 detik.
    _slowTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) setState(() => _state = WritingState.slow);
    });
    _doneTimer = Timer(const Duration(milliseconds: 2500), _openResult);
  }

  void _cancel() {
    _slowTimer?.cancel();
    _doneTimer?.cancel();
    setState(() => _state = WritingState.idle);
  }

  Future<void> _openResult() async {
    _slowTimer?.cancel();
    if (!mounted) return;
    setState(() => _state = WritingState.idle);
    final action = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => WritingResultScreen(text: _controller.text)),
    );
    if (action == 'rewrite') _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Writing',
      bottom: AppButton(
        label: 'Cek grammar',
        loading: _busy,
        loadingLabel: 'Mengecek…',
        onPressed: _controller.text.trim().isEmpty || _overLimit ? null : _check,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          if (_state == WritingState.slow) ...[
            StatusBanner.slow(onAction: _cancel),
            const SizedBox(height: 24),
          ],
          if (_state == WritingState.error) ...[
            StatusBanner.timeout(onAction: _check),
            const SizedBox(height: 24),
          ],
          Text('Tulis kalimat atau paragraf pendek dalam bahasa Inggris.',
              style: AppText.sans(size: 16, height: 1.55)),
          const SizedBox(height: 20),
          LinedPaper(
            height: _state == WritingState.idle && !_overLimit ? 364 : 252,
            child: TextField(
              controller: _controller,
              enabled: !_busy,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: AppText.serif(size: 18, color: AppColors.primary, height: 28 / 18),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Contoh: Yesterday I go to school with my friend.',
                hintStyle: AppText.serif(
                    size: 18, color: AppColors.textSecondary, height: 28 / 18),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_count/${WritingDummy.maxChars}',
              style: AppText.sans(
                size: 13,
                color: _overLimit ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ),
          if (_overLimit) ...[
            const SizedBox(height: 4),
            FieldError('Kurangi ${_count - WritingDummy.maxChars} karakter agar bisa dicek.'),
          ],
          if (_busy) ...[
            const SizedBox(height: 16),
            Text('Teks kamu tersimpan. Tunggu sampai pemeriksaan selesai.', style: AppText.small),
          ],
        ],
      ),
    );
  }
}

// ----------------------------------------------------------- Result screen
class WritingResultScreen extends StatefulWidget {
  const WritingResultScreen({
    super.key,
    required this.text,
    this.startLoading = true,
    this.openRuleSheet = false,
    this.autoCopy = false,
  });

  final String text;
  final bool startLoading;
  final bool openRuleSheet;
  final bool autoCopy;

  @override
  State<WritingResultScreen> createState() => _WritingResultScreenState();
}

class _WritingResultScreenState extends State<WritingResultScreen> {
  late bool _loading = widget.startLoading;

  bool get _hasCorrections =>
      widget.text.trim().toLowerCase() == WritingDummy.sampleInput.toLowerCase();

  int get _correctionCount => WritingDummy.tokens.where((t) => t.isWrong).length;

  @override
  void initState() {
    super.initState();
    if (_loading) {
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) setState(() => _loading = false);
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.openRuleSheet) _showRule(WritingDummy.tokens[2]);
      if (widget.autoCopy) _copy();
    });
  }

  void _copy() {
    Clipboard.setData(ClipboardData(
        text: _hasCorrections ? WritingDummy.correctedText : widget.text));
    showAppSnack(context, 'Teks disalin.');
  }

  void _showRule(CorrectionToken token) {
    final rule = WritingDummy.rules[token.ruleId];
    if (rule == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 8, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(rule.title, style: AppText.title.copyWith(fontSize: 18))),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close, color: AppColors.primary),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(rule.explanation, style: AppText.sans(size: 16, height: 1.55)),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(rule.example,
                        style: AppText.serif(size: 17, style: FontStyle.italic)),
                  ),
                  const SizedBox(height: 24),
                  AppButton(label: 'Mengerti', onPressed: () => Navigator.pop(ctx)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Hasil koreksi',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(label: 'Tulis lagi', onPressed: () => Navigator.pop(context, 'rewrite')),
          const SizedBox(height: 8),
          AppButton.secondary(
              label: 'Edit teks ini', onPressed: () => Navigator.pop(context, 'edit')),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _loading
            ? _buildLoading()
            : _hasCorrections
                ? _buildCorrections()
                : _buildCorrect(),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView(
      key: const ValueKey('loading'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text('Menyiapkan hasil…', style: AppText.h3),
        const SizedBox(height: 20),
        LinedPaper(
          lineHeight: 84,
          minLines: 2,
          child: LayoutBuilder(
            builder: (_, c) => Column(
              children: [
                for (var i = 0; i < 2; i++) ...[
                  const SkeletonBlock(),
                  const SizedBox(height: 16),
                  const SkeletonBlock(),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SkeletonBlock(width: c.maxWidth * 0.69),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorrect() {
    return ListView(
      key: const ValueKey('correct'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 1.4),
                ),
                child: const Icon(Icons.check, size: 13, color: AppColors.success),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Tidak ada kesalahan. Kalimatmu sudah benar.',
                  style: AppText.sans(
                      size: 18, weight: FontWeight.w600, color: AppColors.success, height: 1.4)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LinedText(widget.text, minLines: 5),
        const SizedBox(height: 24),
        AppButton.secondary(label: 'Salin teks', onPressed: _copy),
      ],
    );
  }

  Widget _buildCorrections() {
    return ListView(
      key: const ValueKey('corrections'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text('$_correctionCount bagian perlu diperbaiki', style: AppText.h3),
        const SizedBox(height: 20),
        CorrectionText(tokens: WritingDummy.tokens, onTapCorrection: _showRule),
        const SizedBox(height: 16),
        Text('Ketuk kata yang dicoret untuk memahami koreksinya.', style: AppText.small),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(child: Text('Versi benar', style: AppText.h3)),
            IconButton(
              onPressed: _copy,
              tooltip: 'Salin teks',
              icon: const Icon(Icons.copy_outlined, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(WritingDummy.correctedText,
            style: AppText.serif(size: 18, color: AppColors.primary, height: 1.6)),
      ],
    );
  }
}

