import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/answer_widgets.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/common.dart';

// ----------------------------------------------------------------- Offline
class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  bool _loading = false;

  Future<void> _retry() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _loading = false);
    showAppSnack(context, 'Masih offline (dummy).');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'English Day',
      bottom: AppButton(
        label: 'Coba lagi',
        loading: _loading,
        loadingLabel: 'Menghubungkan…',
        onPressed: _retry,
      ),
      body: const InfoStateView(
        icon: Icons.wifi_off_rounded,
        circleSize: 72,
        title: 'Tidak ada koneksi internet',
        message: 'Periksa jaringanmu, lalu coba lagi.',
      ),
    );
  }
}

// --------------------------------------------------------------- AI status
class AiStatusScreen extends StatelessWidget {
  const AiStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Status latihan',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('Status AI', style: AppText.h2),
          const SizedBox(height: 20),
          Text('Memproses lebih dari 10 detik', style: AppText.caption),
          const SizedBox(height: 8),
          StatusBanner.slow(onAction: () {}),
          const SizedBox(height: 20),
          Text('Timeout · input tetap tersimpan', style: AppText.caption),
          const SizedBox(height: 8),
          StatusBanner.timeout(onAction: () {}),
          const SizedBox(height: 28),
          Text('Memproses kurang dari 10 detik', style: AppText.caption),
          const SizedBox(height: 8),
          const AppButton(label: 'Cek', loading: true, loadingLabel: 'Mengecek…'),
        ],
      ),
    );
  }
}

// --------------------------------------------------- Komponen: tombol
class ButtonsShowcaseScreen extends StatelessWidget {
  const ButtonsShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget caption(String t) => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(t, style: AppText.caption),
        );
    return AppScaffold(
      title: 'Komponen',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('Tombol & aksi', style: AppText.h2),
          caption('Normal · utama'),
          AppButton(label: 'Cek grammar', onPressed: () {}),
          caption('Ditekan · utama'),
          Container(
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryPressed,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text('Cek grammar',
                style: AppText.sans(size: 15, weight: FontWeight.w600, color: Colors.white)),
          ),
          caption('Nonaktif · utama'),
          const AppButton(label: 'Cek grammar'),
          caption('Memuat · utama'),
          const AppButton(label: 'Cek grammar', loading: true, loadingLabel: 'Mengecek…'),
          caption('Sekunder'),
          AppButton.secondary(label: 'Edit teks ini', onPressed: () {}),
          caption('Aksi teks · target 48 dp'),
          Center(child: AppTextAction(label: 'Nanti saja', onPressed: () {})),
        ],
      ),
    );
  }
}

// --------------------------------------------- Komponen: input & pilihan
class InputsShowcaseScreen extends StatefulWidget {
  const InputsShowcaseScreen({super.key});

  @override
  State<InputsShowcaseScreen> createState() => _InputsShowcaseScreenState();
}

class _InputsShowcaseScreenState extends State<InputsShowcaseScreen> {
  String _role = 'Guru';
  final _focus = TextEditingController(text: 'Rina Amelia');
  final _err = TextEditingController(text: '123456');
  final _dis = TextEditingController(text: 'Rina Amelia');

  @override
  void dispose() {
    _focus.dispose();
    _err.dispose();
    _dis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Komponen',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const AppTextField(label: 'Normal', hint: 'Tulis nama kamu'),
          const SizedBox(height: 16),
          AppTextField(label: 'Fokus', controller: _focus),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Kesalahan',
            controller: _err,
            obscure: true,
            errorText: 'Password minimal 8 karakter.',
          ),
          const SizedBox(height: 16),
          AppTextField(label: 'Nonaktif saat diproses', controller: _dis, enabled: false),
          const SizedBox(height: 20),
          Text('Pilihan · normal dan terpilih', style: AppText.caption),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final r in ['Siswa', 'Guru'])
                AppChoiceChip(
                  label: r,
                  selected: _role == r,
                  onTap: () => setState(() => _role = r),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Ikon · target 48 dp, visual 24 dp', style: AppText.caption),
          const SizedBox(height: 4),
          Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.arrow_back, color: AppColors.primary)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined, color: AppColors.primary)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.copy_outlined, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------ Komponen: jawaban & percakapan
class AnswersShowcaseScreen extends StatelessWidget {
  const AnswersShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Komponen',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('Pilihan jawaban', style: AppText.h3),
          const SizedBox(height: 12),
          const AnswerOption(label: 'A. To fix the roof'),
          const AnswerOption(label: 'B. To get his kite back', state: OptionState.selected),
          const AnswerOption(label: 'B. To get his kite back', state: OptionState.correct),
          const AnswerOption(label: 'C. To watch the festival', state: OptionState.wrong),
          const AnswerFeedback(
            correct: true,
            message: 'Benar, Daeng mengambil kembali layang-layangnya.',
          ),
          const SizedBox(height: 16),
          Text('Percakapan', style: AppText.h3),
          const SizedBox(height: 12),
          ChatBubble(text: 'What did you do last weekend?', fromAi: true, onSpeaker: () {}),
          const ChatBubble(text: 'I went to the beach.', fromAi: false),
        ],
      ),
    );
  }
}

