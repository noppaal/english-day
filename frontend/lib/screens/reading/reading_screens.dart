import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/answer_widgets.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/common.dart';
import '../dashboard/dashboard_screen.dart';

// ---------------------------------------------------------------- Settings
class ReadingSettingsScreen extends StatefulWidget {
  const ReadingSettingsScreen({super.key});

  @override
  State<ReadingSettingsScreen> createState() => _ReadingSettingsScreenState();
}

class _ReadingSettingsScreenState extends State<ReadingSettingsScreen> {
  int _level = 1;
  String? _topic = 'Budaya';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Reading',
      bottom: AppButton(
        label: 'Buat cerita',
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ReadingStoryScreen(
            level: ReadingDummy.levels[_level].name,
            topic: _topic ?? 'Acak',
            initialState: StoryState.loading,
          ),
        )),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('Level', style: AppText.h3),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (var i = 0; i < ReadingDummy.levels.length; i++)
                AppChoiceChip(
                  label: ReadingDummy.levels[i].name,
                  subtitle: ReadingDummy.levels[i].cefr,
                  selected: _level == i,
                  onTap: () => setState(() => _level = i),
                ),
            ],
          ),
          const SizedBox(height: 28),
          Text('Topik (opsional)', style: AppText.h3),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              for (final t in ReadingDummy.topics)
                AppChoiceChip(
                  label: t,
                  selected: _topic == t,
                  onTap: () => setState(() => _topic = _topic == t ? null : t),
                ),
            ],
          ),
          const SizedBox(height: 24),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.menu_book_outlined, color: AppColors.primary),
                const SizedBox(height: 16),
                Text('Cerita sekitar 150–250 kata, diikuti 5 soal pilihan ganda.',
                    style: AppText.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------- Story
enum StoryState { loading, slow, error, story }

class ReadingStoryScreen extends StatefulWidget {
  const ReadingStoryScreen({
    super.key,
    this.level = 'Medium',
    this.topic = 'Budaya',
    this.initialState = StoryState.story,
    this.autoLoad = true,
    this.openVocab,
    this.scrollToEnd = false,
  });

  final String level;
  final String topic;
  final StoryState initialState;

  /// Jika true, state loading otomatis berlanjut ke cerita.
  final bool autoLoad;
  final String? openVocab;
  final bool scrollToEnd;

  @override
  State<ReadingStoryScreen> createState() => _ReadingStoryScreenState();
}

class _ReadingStoryScreenState extends State<ReadingStoryScreen> {
  late StoryState _state = widget.initialState;
  final _scroll = ScrollController();
  Timer? _slowTimer;
  Timer? _doneTimer;

  String get _meta => '${widget.level} · ${widget.topic}';

  @override
  void initState() {
    super.initState();
    if (_state == StoryState.loading && widget.autoLoad) _generate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.openVocab != null) _showVocab(widget.openVocab!);
      if (widget.scrollToEnd && _scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    _doneTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _generate() {
    setState(() => _state = StoryState.loading);
    _slowTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) setState(() => _state = StoryState.slow);
    });
    _doneTimer = Timer(const Duration(milliseconds: 2200), () {
      _slowTimer?.cancel();
      if (mounted) setState(() => _state = StoryState.story);
    });
  }

  void _cancel() {
    _slowTimer?.cancel();
    _doneTimer?.cancel();
    Navigator.maybePop(context);
  }

  void _showVocab(String word) {
    final item = ReadingDummy.vocabulary[word];
    if (item == null) return;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 8, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(word, style: AppText.h2)),
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
                  const SizedBox(height: 20),
                  Text(item.meaning,
                      style: AppText.sans(size: 16, color: AppColors.primary)),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(item.example,
                        style: AppText.serif(size: 17, style: FontStyle.italic)),
                  ),
                  const SizedBox(height: 24),
                  AppButton.secondary(
                      label: 'Kembali membaca', onPressed: () => Navigator.pop(ctx)),
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
    final busy = _state == StoryState.loading || _state == StoryState.slow;
    return AppScaffold(
      title: ReadingDummy.storyTitle,
      bottom: _state == StoryState.story
          ? AppButton(
              label: 'Mulai kuis',
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const ReadingQuizScreen())),
            )
          : AppButton(
              label: 'Buat cerita',
              loading: busy,
              loadingLabel: 'Membuat cerita…',
              onPressed: _generate,
            ),
      body: _state == StoryState.story ? _buildStory() : _buildPending(),
    );
  }

  Widget _buildPending() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        MetaLabel(_meta),
        const SizedBox(height: 24),
        if (_state == StoryState.slow) ...[
          StatusBanner.slow(onAction: _cancel),
          const SizedBox(height: 28),
        ],
        if (_state == StoryState.error) ...[
          StatusBanner.timeout(onAction: _generate),
          const SizedBox(height: 28),
        ],
        Text(_state == StoryState.error ? 'Cerita belum tersedia' : 'Membuat cerita…',
            style: AppText.h3),
        const SizedBox(height: 20),
        Text('Pilihan kamu tersimpan: $_meta', style: AppText.small),
        const SizedBox(height: 20),
        const SkeletonParagraph(groups: 2),
        const SkeletonBlock(),
        const SizedBox(height: 16),
        const SkeletonBlock(),
      ],
    );
  }

  Widget _buildStory() {
    final base = AppText.serif(size: 18, height: 1.6);
    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        MetaLabel(_meta),
        const SizedBox(height: 20),
        for (final p in ReadingDummy.paragraphs) ...[
          Text.rich(TextSpan(style: base, children: _spans(p, base))),
          const SizedBox(height: 22),
        ],
        Text('Ketuk kata berstabilo untuk melihat artinya.', style: AppText.small),
      ],
    );
  }

  List<InlineSpan> _spans(String paragraph, TextStyle base) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\[(.+?)\]');
    var last = 0;
    for (final m in regex.allMatches(paragraph)) {
      spans.add(TextSpan(text: paragraph.substring(last, m.start)));
      final word = m.group(1)!;
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: GestureDetector(
          onTap: () => _showVocab(word),
          child: Container(
            color: AppColors.highlight,
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(word, style: base),
          ),
        ),
      ));
      last = m.end;
    }
    spans.add(TextSpan(text: paragraph.substring(last)));
    return spans;
  }
}

// -------------------------------------------------------------------- Quiz
class ReadingQuizScreen extends StatefulWidget {
  const ReadingQuizScreen({
    super.key,
    this.initialIndex = 0,
    this.initialSelected,
    this.initialSubmitted = false,
  });

  final int initialIndex;
  final int? initialSelected;
  final bool initialSubmitted;

  @override
  State<ReadingQuizScreen> createState() => _ReadingQuizScreenState();
}

class _ReadingQuizScreenState extends State<ReadingQuizScreen> {
  late int _index = widget.initialIndex;
  late int? _selected = widget.initialSelected;
  late bool _submitted = widget.initialSubmitted;
  late final List<int?> _answers = List.filled(ReadingDummy.quiz.length, null);

  QuizQuestion get _q => ReadingDummy.quiz[_index];
  int get _total => ReadingDummy.quiz.length;

  void _submit() => setState(() {
        _submitted = true;
        _answers[_index] = _selected;
      });

  void _next() {
    if (_index == _total - 1) {
      // Isi jawaban kosong (jika dibuka dari galeri) dengan jawaban dummy.
      final answers = [
        for (var i = 0; i < _total; i++)
          _answers[i] ?? (i == 3 ? 0 : ReadingDummy.quiz[i].correctIndex),
      ];
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ReadingResultScreen(answers: answers)),
      );
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _submitted = false;
    });
  }

  OptionState _optionState(int i) {
    if (!_submitted) return _selected == i ? OptionState.selected : OptionState.normal;
    if (i == _q.correctIndex) return OptionState.correct;
    if (i == _selected) return OptionState.wrong;
    return OptionState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final correct = _selected == _q.correctIndex;
    return AppScaffold(
      title: 'Kuis',
      leadingIcon: Icons.close,
      bottom: _submitted
          ? AppButton(
              label: _index == _total - 1 ? 'Lihat hasil' : 'Soal berikutnya',
              onPressed: _next,
            )
          : AppButton(
              label: 'Kirim jawaban',
              onPressed: _selected == null ? null : _submit,
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Soal ${_index + 1} dari $_total',
                    style: AppText.sans(size: 14, weight: FontWeight.w600)),
              ),
              Text(ReadingDummy.storyTitle,
                  style: AppText.sans(size: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_index + 1) / _total,
              minHeight: 4,
              backgroundColor: AppColors.divider,
              color: AppColors.progressBrown,
            ),
          ),
          const SizedBox(height: 24),
          Text(_q.question, style: AppText.h2.copyWith(height: 1.35)),
          const SizedBox(height: 20),
          for (var i = 0; i < _q.options.length; i++)
            AnswerOption(
              label: _q.options[i],
              state: _optionState(i),
              onTap: _submitted ? null : () => setState(() => _selected = i),
            ),
          if (_submitted) ...[
            const SizedBox(height: 12),
            AnswerFeedback(
              correct: correct,
              message: correct ? _q.explanation : (_q.wrongHint ?? _q.explanation),
            ),
          ],
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ Result
class ReadingResultScreen extends StatelessWidget {
  const ReadingResultScreen({super.key, required this.answers});
  final List<int> answers;

  @override
  Widget build(BuildContext context) {
    const quiz = ReadingDummy.quiz;
    final score = [for (var i = 0; i < quiz.length; i++) answers[i] == quiz[i].correctIndex]
        .where((e) => e)
        .length;
    return AppScaffold(
      title: 'Hasil kuis',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: 'Buat cerita baru',
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ReadingSettingsScreen()),
            ),
          ),
          const SizedBox(height: 8),
          AppButton.secondary(
            label: 'Kembali ke dashboard',
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (_) => false,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const MetaLabel('${ReadingDummy.storyTitle} · Medium'),
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerLeft, child: ScoreBadge('$score/${quiz.length}')),
          const SizedBox(height: 12),
          Text(
            score == quiz.length
                ? 'Sempurna! Semua jawaban kamu benar.'
                : score >= 3
                    ? 'Bagus! $score jawaban kamu benar.'
                    : '$score jawaban benar. Yuk, baca lagi ceritanya.',
            style: AppText.sans(size: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < quiz.length; i++)
            _ResultItem(
              question: quiz[i],
              correct: answers[i] == quiz[i].correctIndex,
            ),
        ],
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  const _ResultItem({required this.question, required this.correct});
  final QuizQuestion question;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.success : AppColors.error;
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(question.question, style: AppText.h3),
              const SizedBox(height: 16),
              AnswerOption(
                label: question.options[question.correctIndex],
                state: OptionState.correct,
              ),
              AnswerFeedback(correct: correct, message: question.explanation),
              const SizedBox(height: 16),
              AppButton.secondary(label: 'Tutup', onPressed: () => Navigator.pop(ctx)),
            ],
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
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
                  Text(question.question,
                      style: AppText.sans(size: 15, weight: FontWeight.w600, height: 1.4)),
                  const SizedBox(height: 4),
                  Text('${correct ? 'Benar' : 'Belum tepat'} · ${question.reviewAnswer}',
                      style: AppText.small),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

