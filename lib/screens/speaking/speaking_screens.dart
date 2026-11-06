import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/answer_widgets.dart';
import '../../widgets/app_button.dart';
import '../../widgets/common.dart';

// ------------------------------------------------------- Izin mikrofon
class MicPermissionScreen extends StatelessWidget {
  const MicPermissionScreen({super.key, this.permanentlyDenied = false});
  final bool permanentlyDenied;

  void _goSpeaking(BuildContext context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SpeakingScreen()),
      );

  @override
  Widget build(BuildContext context) {
    if (permanentlyDenied) {
      return AppScaffold(
        title: 'Speaking',
        bottom: AppButton(
          label: 'Buka pengaturan',
          onPressed: () {
            showAppSnack(context, 'Membuka pengaturan (dummy)…');
            Future.delayed(const Duration(milliseconds: 900), () {
              if (context.mounted) _goSpeaking(context);
            });
          },
        ),
        body: const InfoStateView(
          icon: Icons.mic_off_outlined,
          title: 'Akses mikrofon dimatikan',
          message: 'Speaking butuh akses mikrofon. Buka pengaturan untuk mengizinkannya.',
        ),
      );
    }
    return AppScaffold(
      title: 'Speaking',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(label: 'Izinkan mikrofon', onPressed: () => _goSpeaking(context)),
          const SizedBox(height: 8),
          AppTextAction(label: 'Nanti saja', onPressed: () => Navigator.maybePop(context)),
        ],
      ),
      body: const InfoStateView(
        icon: Icons.mic_none_rounded,
        title: 'Izinkan mikrofon untuk latihan Speaking',
        message: 'Suaramu hanya dipakai untuk mengubah ucapan menjadi teks selama latihan.',
      ),
    );
  }
}

// ---------------------------------------------------------- Percakapan
enum SpeakingState { idle, recording, processing, aiSpeaking, slow, error }

class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({
    super.key,
    this.initialState = SpeakingState.idle,
    this.withHistory = false,
  });

  final SpeakingState initialState;
  final bool withHistory;

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  late SpeakingState _state = widget.initialState;
  late final List<ChatMessage> _messages = widget.withHistory
      ? List.of(SpeakingDummy.conversation)
      : [SpeakingDummy.opening];
  late int _turn = widget.withHistory ? 1 : 0;
  int? _speakingIndex;
  String _live = '';
  Timer? _timer;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    if (_state == SpeakingState.aiSpeaking) _speakingIndex = _messages.length - 1;
    if (_state == SpeakingState.recording) _live = SpeakingDummy.liveTranscript;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  String get _nextUserReply =>
      SpeakingDummy.userReplies[_turn % SpeakingDummy.userReplies.length];
  String get _nextAiReply => SpeakingDummy.aiReplies[_turn % SpeakingDummy.aiReplies.length];

  void _startRecording() {
    _timer?.cancel();
    final words = _nextUserReply.split(' ');
    var i = 0;
    setState(() {
      _state = SpeakingState.recording;
      _live = '';
    });
    // Simulasi transkrip live kata per kata.
    _timer = Timer.periodic(const Duration(milliseconds: 380), (t) {
      if (i >= words.length) {
        t.cancel();
        return;
      }
      setState(() => _live = words.sublist(0, ++i).join(' '));
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    setState(() => _state = SpeakingState.processing);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted || _state != SpeakingState.processing) return;
    setState(() => _messages.add(ChatMessage(_nextUserReply, fromAi: false)));
    _scrollDown();
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted || _state != SpeakingState.processing) return;
    setState(() {
      _messages.add(ChatMessage(_nextAiReply, fromAi: true));
      _turn++;
    });
    _scrollDown();
    _playAi(_messages.length - 1);
  }

  void _playAi(int index) {
    _timer?.cancel();
    setState(() {
      _state = SpeakingState.aiSpeaking;
      _speakingIndex = index;
    });
    _timer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        setState(() {
          _state = SpeakingState.idle;
          _speakingIndex = null;
        });
      }
    });
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Speaking',
      action: AppTextAction(label: 'Akhiri', onPressed: () => Navigator.maybePop(context)),
      bottom: _buildControls(),
      body: ListView(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          if (_state == SpeakingState.slow) ...[
            StatusBanner.slow(onAction: () => setState(() => _state = SpeakingState.idle)),
            const SizedBox(height: 24),
          ],
          if (_state == SpeakingState.error) ...[
            StatusBanner(
              type: BannerType.error,
              message: 'Suaramu tidak terdengar jelas. Coba bicara lebih dekat ke HP.',
              actionLabel: 'Coba lagi',
              onAction: _startRecording,
            ),
            const SizedBox(height: 24),
          ],
          for (var i = 0; i < _messages.length; i++)
            ChatBubble(
              text: _messages[i].text,
              fromAi: _messages[i].fromAi,
              speaking: _speakingIndex == i,
              onSpeaker: _state == SpeakingState.idle ? () => _playAi(i) : null,
            ),
          if (_messages.length == 1) ...[
            const SizedBox(height: 12),
            Text('Jawab dengan suaramu dalam bahasa Inggris.', style: AppText.body),
          ],
        ],
      ),
    );
  }

  Widget _buildControls() {
    late Widget button;
    late String label;
    switch (_state) {
      case SpeakingState.idle:
      case SpeakingState.error:
        label = 'Tekan untuk bicara';
        button = _MicButton(
          onTap: _startRecording,
          child: const Icon(Icons.mic_none_rounded, color: Colors.white, size: 28),
        );
      case SpeakingState.recording:
        label = 'Mendengarkan…';
        button = Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
          child: _MicButton(
            size: 60,
            onTap: _stopRecording,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.6),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        );
      case SpeakingState.processing:
      case SpeakingState.slow:
        label = 'Memproses…';
        button = const _MicButton(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
        );
      case SpeakingState.aiSpeaking:
        label = 'AI sedang berbicara…';
        button = const _MicButton(
          color: AppColors.disabled,
          child: Icon(Icons.mic_none_rounded, color: AppColors.disabledText, size: 28),
        );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_state == SpeakingState.recording) ...[
          const SizedBox(height: 4),
          Text(_live.isEmpty ? '…' : _live,
              textAlign: TextAlign.center,
              style: AppText.sans(size: 16, color: AppColors.primary)),
          const SizedBox(height: 12),
          const SoundWave(),
          const SizedBox(height: 12),
        ],
        button,
        const SizedBox(height: 10),
        Text(label,
            style: AppText.sans(size: 15, weight: FontWeight.w600, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MicButton extends StatelessWidget {
  const _MicButton({required this.child, this.onTap, this.size = 72, this.color});
  final Widget child;
  final VoidCallback? onTap;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: size, height: size, child: Center(child: child)),
      ),
    );
  }
}

