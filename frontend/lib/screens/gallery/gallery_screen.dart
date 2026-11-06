import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../auth/auth_screens.dart';
import '../dashboard/dashboard_screen.dart';
import '../global/global_screens.dart';
import '../listening/listening_screen.dart';
import '../profile/profile_screen.dart';
import '../reading/reading_screens.dart';
import '../speaking/speaking_screens.dart';
import '../writing/writing_screens.dart';

/// Galeri semua layar & state sesuai file desain, untuk review slicing.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static final Map<String, List<(String, WidgetBuilder)>> _groups = {
    'Akun': [
      ('splash', (_) => const SplashScreen(autoNavigate: false)),
      ('login', (_) => const LoginScreen()),
      ('login-loading', (_) => const _FrozenLogin()),
      ('login-error', (_) => const LoginScreen(initialState: LoginState.error)),
      ('register', (_) => const RegisterScreen()),
      ('register-error', (_) => const RegisterScreen(showErrors: true)),
    ],
    'Dashboard': [
      ('lanjutkan latihan', (_) => const DashboardScreen()),
      ('pengguna baru', (_) => const DashboardScreen(hasProgress: false)),
    ],
    'Global': [
      ('banner AI', (_) => const AiStatusScreen()),
      ('offline', (_) => const OfflineScreen()),
      ('sesi habis', (_) => const DashboardScreen(showSessionExpired: true)),
      (
        'teks disalin',
        (_) => const WritingResultScreen(
              text: WritingDummy.sampleInput,
              startLoading: false,
              autoCopy: true,
            )
      ),
    ],
    'Izin mikrofon': [
      ('permintaan', (_) => const MicPermissionScreen()),
      ('ditolak permanen', (_) => const MicPermissionScreen(permanentlyDenied: true)),
    ],
    'Komponen': [
      ('input dan pilihan', (_) => const InputsShowcaseScreen()),
      ('jawaban dan percakapan', (_) => const AnswersShowcaseScreen()),
      ('tombol', (_) => const ButtonsShowcaseScreen()),
    ],
    'Profil': [
      ('profil', (_) => const ProfileScreen()),
      ('konfirmasi keluar', (_) => const ProfileScreen(showLogoutConfirm: true)),
    ],
    'Writing': [
      ('input empty', (_) => const WritingInputScreen()),
      ('input filled', (_) => const WritingInputScreen(initialText: WritingDummy.sampleInput)),
      (
        'input loading',
        (_) => const WritingInputScreen(
            initialText: WritingDummy.sampleInput, initialState: WritingState.loading)
      ),
      (
        'input slow',
        (_) => const WritingInputScreen(
            initialText: WritingDummy.sampleInput, initialState: WritingState.slow)
      ),
      (
        'input error',
        (_) => const WritingInputScreen(
            initialText: WritingDummy.sampleInput, initialState: WritingState.error)
      ),
      ('input limit', (_) => const WritingInputScreen(initialText: WritingDummy.longInput)),
      (
        'hasil loading',
        (_) => const WritingResultScreen(text: WritingDummy.sampleInput)
      ),
      (
        'hasil corrections',
        (_) => const WritingResultScreen(text: WritingDummy.sampleInput, startLoading: false)
      ),
      (
        'hasil sheet',
        (_) => const WritingResultScreen(
            text: WritingDummy.sampleInput, startLoading: false, openRuleSheet: true)
      ),
      (
        'hasil correct',
        (_) => const WritingResultScreen(text: WritingDummy.correctedText, startLoading: false)
      ),
    ],
    'Reading': [
      ('pengaturan', (_) => const ReadingSettingsScreen()),
      (
        'cerita loading',
        (_) => const ReadingStoryScreen(initialState: StoryState.loading, autoLoad: false)
      ),
      ('cerita slow', (_) => const ReadingStoryScreen(initialState: StoryState.slow)),
      ('cerita error', (_) => const ReadingStoryScreen(initialState: StoryState.error)),
      ('cerita story', (_) => const ReadingStoryScreen()),
      ('cerita continuation', (_) => const ReadingStoryScreen(scrollToEnd: true)),
      ('cerita sheet', (_) => const ReadingStoryScreen(openVocab: 'drifted')),
      ('kuis empty', (_) => const ReadingQuizScreen(initialIndex: 1)),
      ('kuis selected', (_) => const ReadingQuizScreen(initialIndex: 1, initialSelected: 1)),
      (
        'kuis correct',
        (_) => const ReadingQuizScreen(
            initialIndex: 1, initialSelected: 1, initialSubmitted: true)
      ),
      (
        'kuis wrong',
        (_) => const ReadingQuizScreen(
            initialIndex: 1, initialSelected: 2, initialSubmitted: true)
      ),
      ('kuis result', (_) => const ReadingResultScreen(answers: [1, 1, 2, 0, 1])),
    ],
    'Speaking': [
      ('empty', (_) => const SpeakingScreen()),
      ('idle', (_) => const SpeakingScreen(withHistory: true)),
      (
        'recording',
        (_) => const SpeakingScreen(withHistory: true, initialState: SpeakingState.recording)
      ),
      (
        'processing',
        (_) => const SpeakingScreen(withHistory: true, initialState: SpeakingState.processing)
      ),
      (
        'speaking',
        (_) => const SpeakingScreen(withHistory: true, initialState: SpeakingState.aiSpeaking)
      ),
      (
        'slow',
        (_) => const SpeakingScreen(withHistory: true, initialState: SpeakingState.slow)
      ),
      (
        'error',
        (_) => const SpeakingScreen(withHistory: true, initialState: SpeakingState.error)
      ),
    ],
    'Listening': [
      ('empty', (_) => const ListeningScreen()),
      (
        'loading',
        (_) => const ListeningScreen(initialPhase: ListeningPhase.loading, freeze: true)
      ),
      (
        'slow',
        (_) => const ListeningScreen(initialPhase: ListeningPhase.slow, freeze: true)
      ),
      (
        'playing',
        (_) => const ListeningScreen(
            initialPhase: ListeningPhase.practice,
            initialAnswers: [0, null, null],
            autoPlay: true)
      ),
      (
        'questions',
        (_) => const ListeningScreen(
            initialPhase: ListeningPhase.practice, initialAnswers: [0, 1, 2])
      ),
      (
        'locked',
        (_) => const ListeningScreen(
            initialPhase: ListeningPhase.practice,
            initialAnswers: [0, 1, 2],
            scrollToLast: true)
      ),
      (
        'error',
        (_) => const ListeningScreen(
            initialPhase: ListeningPhase.audioError, initialAnswers: [0, null, null])
      ),
      (
        'result',
        (_) => const ListeningScreen(
            initialPhase: ListeningPhase.result, initialAnswers: [0, 1, 2])
      ),
      (
        'review',
        (_) => const ListeningScreen(
            initialPhase: ListeningPhase.result,
            initialAnswers: [0, 1, 2],
            focus: ResultFocus.review)
      ),
      (
        'transcript',
        (_) => const ListeningScreen(
            initialPhase: ListeningPhase.result,
            initialAnswers: [0, 1, 2],
            focus: ResultFocus.transcript)
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final total = _groups.values.fold<int>(0, (a, b) => a + b.length);
    return AppScaffold(
      title: 'Tentang aplikasi',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(AppInfo.appName, style: AppText.display),
          const SizedBox(height: 4),
          Text('${AppInfo.tagline} · Versi ${AppInfo.version}', style: AppText.caption),
          const SizedBox(height: 24),
          Text('Galeri UI ($total layar)', style: AppText.h3),
          const SizedBox(height: 4),
          Text('Buka setiap layar & state sesuai file desain. Semua data adalah dummy.',
              style: AppText.caption),
          const SizedBox(height: 16),
          for (final entry in _groups.entries) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Text(entry.key,
                  style: AppText.sans(
                      size: 14, weight: FontWeight.w700, color: AppColors.primary)),
            ),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < entry.value.length; i++)
                    InkWell(
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: entry.value[i].$2)),
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: i == entry.value.length - 1
                              ? null
                              : const Border(bottom: BorderSide(color: AppColors.divider)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${entry.key} · ${entry.value[i].$1}',
                                  style: AppText.sans(size: 15, weight: FontWeight.w500)),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Login dalam state loading (statis, untuk galeri).
class _FrozenLogin extends StatelessWidget {
  const _FrozenLogin();

  @override
  Widget build(BuildContext context) => const LoginScreen(initialState: LoginState.loading);
}

