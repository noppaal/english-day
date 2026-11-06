import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/answer_widgets.dart';
import '../../widgets/app_button.dart';
import '../../widgets/common.dart';

enum ListeningPhase { intro, loading, slow, practice, audioError, result }

enum ResultFocus { top, review, transcript }

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({
    super.key,
    this.initialPhase = ListeningPhase.intro,
    this.initialAnswers,
    this.autoPlay = false,
    this.focus = ResultFocus.top,
    this.scrollToLast = false,
    this.freeze = false,
  });

  final ListeningPhase initialPhase;
  final List<int?>? initialAnswers;
  final bool autoPlay;
  final ResultFocus focus;

  /// Scroll ke pertanyaan terakhir (state "locked").
  final bool scrollToLast;

  /// Jika true, state loading tidak otomatis berlanjut (untuk galeri).
  final bool freeze;

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  late ListeningPhase _phase = widget.initialPhase;
  late final List<int?> _answers =
      List.of(widget.initialAnswers ?? List<int?>.filled(ListeningDummy.questions.length, null));

  final _scroll = ScrollController();
  final _reviewKey = GlobalKey();
  final _transcriptKey = GlobalKey();
  final _lastQuestionKey = GlobalKey();

  double _position = 42; // detik
  bool _playing = false;
  double _speed = 1.0;
  Timer? _ticker;
  Timer? _loadTimer;
  Timer? _slowTimer;

  @override
  void initState() {
    super.initState();
    if (_phase == ListeningPhase.loading && !widget.freeze) _load();
    if (widget.autoPlay) _play();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = switch (widget.focus) {
        ResultFocus.review => _reviewKey,
        ResultFocus.transcript => _transcriptKey,
        ResultFocus.top => widget.scrollToLast ? _lastQuestionKey : null,
      };
      final ctx = key?.currentContext;
      if (ctx != null) Scrollable.ensureVisible(ctx, alignment: 0.02);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _loadTimer?.cancel();
    _slowTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  // ------------------------------------------------------ simulasi audio
  void _load() {
    setState(() {
      _phase = ListeningPhase.loading;
      _position = 0;
    });
    _slowTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) setState(() => _phase = ListeningPhase.slow);
    });
    _loadTimer = Timer(const Duration(milliseconds: 2000), () {
      _slowTimer?.cancel();
      if (!mounted) return;
      setState(() => _phase = ListeningPhase.practice);
      _play();
    });
  }

  void _cancelLoad() {
    _slowTimer?.cancel();
    _loadTimer?.cancel();
    setState(() => _phase = ListeningPhase.intro);
  }

  void _play() {
    _ticker?.cancel();
    if (_position >= ListeningDummy.durationSec) _position = 0;
    setState(() => _playing = true);
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (t) {
      setState(() {
        _position += 0.2 * _speed;
        if (_position >= ListeningDummy.durationSec) {
          _position = ListeningDummy.durationSec.toDouble();
          _playing = false;
          t.cancel();
        }
      });
    });
  }

  void _pause() {
    _ticker?.cancel();
    setState(() => _playing = false);
  }

  void _replay() {
    setState(() => _position = 0);
    if (_phase == ListeningPhase.practice) _play();
  }

  void _submit() {
    if (_answers.contains(null)) {
      showAppSnack(context, 'Jawab semua pertanyaan dulu, ya.');
      return;
    }
    _pause();
    setState(() => _phase = ListeningPhase.result);
    _scroll.jumpTo(0);
  }

  void _restart() {
    _ticker?.cancel();
    setState(() {
      for (var i = 0; i < _answers.length; i++) {
        _answers[i] = null;
      }
      _playing = false;
      _phase = ListeningPhase.intro;
    });
  }

  String _fmt(double s) {
    final sec = s.floor();
    return '${sec ~/ 60}:${(sec % 60).toString().padLeft(2, '0')}';
  }

  // ------------------------------------------------------------- build
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Listening',
      bottom: _buildBottom(),
      body: _phase == ListeningPhase.intro
          ? _buildIntro()
          : ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const MetaLabel(ListeningDummy.meta),
                const SizedBox(height: 24),
                ..._phase == ListeningPhase.result ? _buildResult() : _buildPractice(),
              ],
            ),
    );
  }

  Widget _buildBottom() {
    switch (_phase) {
      case ListeningPhase.intro:
        return AppButton(label: 'Mulai latihan', onPressed: _load);
      case ListeningPhase.loading:
      case ListeningPhase.slow:
        return const _DisabledLoadingButton(label: 'Menyiapkan audio…');
      case ListeningPhase.practice:
      case ListeningPhase.audioError:
        return AppButton(label: 'Kirim jawaban', onPressed: _submit);
      case ListeningPhase.result:
        return AppButton(label: 'Latihan baru', onPressed: _restart);
    }
  }

  Widget _buildIntro() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const MetaLabel(ListeningDummy.meta),
        const SizedBox(height: 80),
        const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.headphones_outlined, color: AppColors.primary, size: 48),
        ),
        const SizedBox(height: 20),
        Text('Latih telingamu, satu percakapan dulu.', style: AppText.h2.copyWith(height: 1.35)),
        const SizedBox(height: 20),
        Text(
          'Dengarkan percakapan di kantin sekolah, lalu jawab '
          '${ListeningDummy.questions.length} pertanyaan. Kamu bisa memutar ulang audio.',
          style: AppText.body,
        ),
      ],
    );
  }

  List<Widget> _buildPractice() {
    final loading = _phase == ListeningPhase.loading || _phase == ListeningPhase.slow;
    return [
      if (_phase == ListeningPhase.slow) ...[
        StatusBanner.slow(onAction: _cancelLoad),
        const SizedBox(height: 24),
      ],
      if (_phase == ListeningPhase.audioError) ...[
        StatusBanner(
          type: BannerType.error,
          message: 'Audio gagal dimuat karena koneksi terputus. Jawaban kamu tetap tersimpan.',
          actionLabel: 'Coba lagi',
          onAction: () {
            setState(() => _phase = ListeningPhase.practice);
            _play();
          },
        ),
        const SizedBox(height: 24),
      ],
      _buildPlayer(loading),
      const SizedBox(height: 28),
      if (loading) ...[
        Text('Menyiapkan pertanyaan untuk kamu…',
            style: AppText.sans(size: 15, weight: FontWeight.w500, color: AppColors.textSecondary)),
        const SizedBox(height: 24),
        const SkeletonParagraph(groups: 2, withTitle: false),
      ] else ...[
        for (var q = 0; q < ListeningDummy.questions.length; q++)
          _QuestionBlock(
            key: q == ListeningDummy.questions.length - 1 ? _lastQuestionKey : null,
            number: q + 1,
            question: ListeningDummy.questions[q],
            selected: _answers[q],
            onSelect: (i) => setState(() => _answers[q] = i),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.lock_outline, color: AppColors.textSecondary),
            const SizedBox(width: 10),
            Text('Transkrip', style: AppText.h3),
          ],
        ),
        const SizedBox(height: 10),
        Text('Jawab semua pertanyaan untuk membuka transkrip.',
            style: AppText.sans(size: 15, color: AppColors.textSecondary, height: 1.45)),
      ],
    ];
  }

  Widget _buildPlayer(bool loading) {
    final progress = loading ? 0.0 : _position / ListeningDummy.durationSec;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ListeningDummy.title, style: AppText.h3.copyWith(fontSize: 20)),
          const SizedBox(height: 16),
          Row(
            children: [
              Material(
                color: loading ? AppColors.disabled : AppColors.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: loading ? null : (_playing ? _pause : _play),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Center(
                      child: loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.textSecondary),
                            )
                          : Icon(
                              _playing ? Icons.pause_rounded : Icons.play_arrow_outlined,
                              color: Colors.white,
                              size: 34,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: AppColors.divider,
                        color: AppColors.progressPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loading
                          ? 'Menyiapkan audio…'
                          : '${_fmt(_position)} / ${_fmt(ListeningDummy.durationSec.toDouble())}',
                      style: AppText.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: loading ? null : _replay,
                icon: const Icon(Icons.replay, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text('Kecepatan', style: AppText.small),
              const Spacer(),
              _SpeedChip(
                label: '0,75×',
                selected: _speed == 0.75,
                onTap: () => setState(() => _speed = 0.75),
              ),
              const SizedBox(width: 8),
              _SpeedChip(
                label: '1×',
                selected: _speed == 1.0,
                onTap: () => setState(() => _speed = 1.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildResult() {
    const qs = ListeningDummy.questions;
    final score = [for (var i = 0; i < qs.length; i++) _answers[i] == qs[i].correctIndex]
        .where((e) => e)
        .length;
    final wrong = qs.length - score;
    return [
      Text('Hasil latihan', style: AppText.h3.copyWith(fontSize: 20)),
      const SizedBox(height: 8),
      Align(alignment: Alignment.centerLeft, child: ScoreBadge('$score/${qs.length}')),
      const SizedBox(height: 12),
      Text(
        wrong == 0
            ? 'Semua jawaban benar. Hebat!'
            : '$score jawaban benar. Yuk, pahami $wrong bagian lagi.',
        style: AppText.body,
      ),
      const SizedBox(height: 20),
      for (var q = 0; q < qs.length; q++)
        _ReviewBlock(
          key: q == 1 ? _reviewKey : null,
          number: q + 1,
          question: qs[q],
          selected: _answers[q] ?? 0,
        ),
      const SizedBox(height: 8),
      Row(
        key: _transcriptKey,
        children: [
          const Icon(Icons.lock_open_outlined, color: AppColors.primary),
          const SizedBox(width: 10),
          Text('Transkrip', style: AppText.h3),
        ],
      ),
      const SizedBox(height: 6),
      Text('${ListeningDummy.title} · Kalimat bukti diberi stabilo.', style: AppText.small),
      const SizedBox(height: 12),
      for (final (line, evidence) in ListeningDummy.transcript)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 2),
          color: evidence ? AppColors.highlight : null,
          child: Text(line, style: AppText.serif(size: 18, height: 1.55)),
        ),
    ];
  }
}

/// Tombol loading dengan tampilan nonaktif (abu-abu) seperti desain.
class _DisabledLoadingButton extends StatelessWidget {
  const _DisabledLoadingButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.disabled,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Text(label,
                style: AppText.sans(
                    size: 17, weight: FontWeight.w500, color: AppColors.textSecondary)),
          ],
        ),
      );
}

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primarySoft : AppColors.surface,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 72,
          height: 48,
          child: Center(
            child: Text(label,
                style: AppText.sans(
                  size: 15,
                  weight: FontWeight.w600,
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                )),
          ),
        ),
      ),
    );
  }
}

class _QuestionBlock extends StatelessWidget {
  const _QuestionBlock({
    super.key,
    required this.number,
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  final int number;
  final QuizQuestion question;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pertanyaan $number', style: AppText.small),
          const SizedBox(height: 8),
          Text(question.question, style: AppText.h3),
          const SizedBox(height: 12),
          for (var i = 0; i < question.options.length; i++)
            AnswerOption(
              label: question.options[i],
              state: selected == i ? OptionState.selected : OptionState.normal,
              onTap: () => onSelect(i),
            ),
        ],
      ),
    );
  }
}

class _ReviewBlock extends StatelessWidget {
  const _ReviewBlock({
    super.key,
    required this.number,
    required this.question,
    required this.selected,
  });

  final int number;
  final QuizQuestion question;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final correct = selected == question.correctIndex;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pertanyaan $number', style: AppText.small),
          const SizedBox(height: 8),
          Text(question.question, style: AppText.h3),
          const SizedBox(height: 12),
          AnswerOption(
            label: question.options[question.correctIndex],
            state: OptionState.correct,
          ),
          if (!correct)
            AnswerOption(label: question.options[selected], state: OptionState.wrong),
          AnswerFeedback(correct: correct, message: question.explanation),
        ],
      ),
    );
  }
}
