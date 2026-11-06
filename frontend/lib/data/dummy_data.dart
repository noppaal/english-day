import '../widgets/lined_paper.dart';

/// Semua data dummy aplikasi (tanpa backend).
class DummyUser {
  static const name = 'Rina Amelia';
  static const firstName = 'Rina';
  static const initials = 'RA';
  static const email = 'rina.amelia@sman10gowa.sch.id';
  static const password = 'password123';
  static const role = 'Siswa';
}

class AppInfo {
  static const appName = 'English Day';
  static const school = 'SMAN 10 Gowa';
  static const tagline = 'English Day · SMAN 10 Gowa';
  static const version = '1.0';
}

// ---------------------------------------------------------------- Writing
class WritingDummy {
  static const sampleInput = 'Yesterday I go to school with my friend and we was late.';
  static const correctedText = 'Yesterday I went to school with my friend and we were late.';
  static const maxChars = 500;

  static const longInput =
      'Last Friday, our class visited a museum in Gowa to learn about local history. '
      'I went with my friend Rina, and we took notes about traditional houses, old maps, '
      'and the stories of our grandparents. After the visit our teacher asked us to write '
      'a short report in English. I wanted to describe everything, but I kept adding more '
      'details about the paintings, the friendly guide, and the quiet garden outside. '
      'Next time, I will choose the most important ideas first so my writing is shorter.';

  static const tokens = <CorrectionToken>[
    CorrectionToken('Yesterday'),
    CorrectionToken('I'),
    CorrectionToken('go', correction: 'went', ruleId: 'past'),
    CorrectionToken('to'),
    CorrectionToken('school'),
    CorrectionToken('with'),
    CorrectionToken('my'),
    CorrectionToken('friend'),
    CorrectionToken('and'),
    CorrectionToken('we'),
    CorrectionToken('was', correction: 'were', ruleId: 'agreement'),
    CorrectionToken('late.'),
  ];

  static const rules = <String, GrammarRule>{
    'past': GrammarRule(
      title: 'Bentuk lampau (past tense)',
      explanation:
          "Kata 'yesterday' menunjukkan waktu lampau, jadi 'go' diganti 'went'.",
      example: 'Last week, she went to the library.',
    ),
    'agreement': GrammarRule(
      title: 'Kesesuaian subjek (were/was)',
      explanation:
          "Subjek 'we' adalah jamak, jadi bentuk lampau 'be' yang tepat adalah 'were', bukan 'was'.",
      example: 'They were happy after the game.',
    ),
  };
}

class GrammarRule {
  const GrammarRule({required this.title, required this.explanation, required this.example});
  final String title;
  final String explanation;
  final String example;
}

// ---------------------------------------------------------------- Reading
class ReadingLevel {
  const ReadingLevel(this.name, this.cefr);
  final String name;
  final String cefr;
}

class ReadingDummy {
  static const levels = [
    ReadingLevel('Easy', 'A2'),
    ReadingLevel('Medium', 'B1'),
    ReadingLevel('Hard', 'B2'),
  ];
  static const topics = ['Sekolah', 'Olahraga', 'Teknologi', 'Budaya', 'Alam', 'Acak'];

  static const storyTitle = 'The Lost Kite';

  /// Paragraf cerita. Kata dalam [kurung siku] = kosakata berstabilo.
  static const paragraphs = [
    'Every August, Daeng joined the kite festival near his home in Gowa. This year, he '
        'brought a blue kite that he had made with his father. Families filled the field, '
        'sharing food and cheering as bright kites rose above them. Daeng felt proud when '
        'his kite flew higher than the tall mango trees.',
    'Suddenly, a strong [gust] pulled the string from his hand. His kite [drifted] across '
        'the field and landed on the [rooftop] of a small shop. Daeng asked the shopkeeper '
        'for help. She showed him a safe ladder behind the building. With his father '
        'holding it steady, Daeng climbed up slowly to get his kite back.',
    'From the roof, he could see the whole festival. His friends waved from below, but '
        'Daeng kept his eyes on the kite. He carefully picked it up and climbed down. He '
        'was [grateful] for everyone\u2019s help. Before flying again, he tied the string '
        'firmly around his wrist. The afternoon ended with laughter, and Daeng learned '
        'that asking for help could turn a problem into a happy memory.',
  ];

  static const vocabulary = <String, VocabItem>{
    'gust': VocabItem('hembusan angin kencang', 'A gust of wind closed the door.'),
    'drifted': VocabItem('terbawa (angin/arus)', 'The boat drifted toward the shore.'),
    'rooftop': VocabItem('atap bangunan', 'We watched the fireworks from the rooftop.'),
    'grateful': VocabItem('bersyukur; berterima kasih', 'I am grateful for your help.'),
  };

  static const quiz = <QuizQuestion>[
    QuizQuestion(
      question: 'Where was the festival?',
      options: ['A. In Makassar', 'B. In Gowa', 'C. In Bira', 'D. At school'],
      correctIndex: 1,
      explanation: 'Festivalnya diadakan di dekat rumah Daeng di Gowa.',
      reviewAnswer: 'In Gowa.',
    ),
    QuizQuestion(
      question: 'Why did Daeng climb onto the rooftop?',
      options: [
        'A. To fix the roof',
        'B. To get his kite back',
        'C. To watch the festival',
        'D. To call his friend',
      ],
      correctIndex: 1,
      explanation: 'Daeng naik untuk mengambil kembali layang-layangnya.',
      wrongHint:
          'Coba ingat tujuan Daeng: layang-layangnya tersangkut di atap, bukan untuk menonton festival.',
      reviewAnswer: 'To get his kite back.',
    ),
    QuizQuestion(
      question: 'What colour was the kite?',
      options: ['A. Red', 'B. Yellow', 'C. Blue', 'D. Green'],
      correctIndex: 2,
      explanation: 'Daeng membawa layang-layang berwarna biru.',
      reviewAnswer: 'Blue.',
    ),
    QuizQuestion(
      question: 'Who held the ladder steady?',
      options: ['A. His friends', 'B. The shopkeeper', 'C. His father', 'D. His teacher'],
      correctIndex: 2,
      explanation: 'Ayah Daeng yang memegangi tangga.',
      wrongHint: 'Baca lagi paragraf kedua: siapa yang memegangi tangga untuk Daeng?',
      reviewAnswer: 'His father, not his friends.',
    ),
    QuizQuestion(
      question: 'What did Daeng learn?',
      options: [
        'A. Kites are dangerous',
        'B. It is okay to ask for help',
        'C. Climbing is fun',
        'D. Festivals are too crowded',
      ],
      correctIndex: 1,
      explanation: 'Daeng belajar bahwa meminta bantuan itu baik.',
      reviewAnswer: 'It is okay to ask for help.',
    ),
  ];
}

class VocabItem {
  const VocabItem(this.meaning, this.example);
  final String meaning;
  final String example;
}

class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.wrongHint,
    this.reviewAnswer = '',
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String? wrongHint;
  final String reviewAnswer;
}

// ---------------------------------------------------------------- Speaking
class ChatMessage {
  const ChatMessage(this.text, {required this.fromAi});
  final String text;
  final bool fromAi;
}

class SpeakingDummy {
  static const opening = ChatMessage('Hi Rina! What did you do last weekend?', fromAi: true);

  static const conversation = <ChatMessage>[
    opening,
    ChatMessage('I went to the beach with my family.', fromAi: false),
    ChatMessage('That sounds fun! Which beach did you visit?', fromAi: true),
  ];

  static const liveTranscript = 'We visited Bira Beach and…';

  /// Balasan dummy AI bergiliran.
  static const userReplies = [
    'I went to the beach with my family.',
    'We visited Bira Beach and swam in the sea.',
    'Yes, I ate grilled fish with my brother.',
    'I want to go there again next holiday.',
  ];
  static const aiReplies = [
    'That sounds fun! Which beach did you visit?',
    'Wow, Bira Beach is beautiful! What else did you do there?',
    'Grilled fish sounds delicious! Would you go back again?',
    'Great! Thanks for sharing your story, Rina. Your English is getting better!',
  ];
}

// ---------------------------------------------------------------- Listening
class ListeningDummy {
  static const meta = 'Medium · Sekolah';
  static const title = 'At the School Canteen';
  static const durationSec = 90;

  static const questions = <QuizQuestion>[
    QuizQuestion(
      question: 'What does Andi want to buy?',
      options: ['A. A chicken sandwich', 'B. A bowl of noodles', 'C. A bottle of water'],
      correctIndex: 0,
      explanation: 'Andi berkata, \u201cI\u2019d like a chicken sandwich, please.\u201d',
    ),
    QuizQuestion(
      question: 'How much is the sandwich?',
      options: [
        'A. Ten thousand rupiah',
        'B. Fifteen thousand rupiah',
        'C. Twenty thousand rupiah',
      ],
      correctIndex: 1,
      explanation: 'Mira menyebut harganya lima belas ribu rupiah.',
    ),
    QuizQuestion(
      question: 'What will Andi do next?',
      options: [
        'A. Sit near the window',
        'B. Buy another sandwich',
        'C. Return to his classroom',
      ],
      correctIndex: 0,
      explanation: 'Andi akan duduk di dekat jendela, bukan kembali ke kelas.',
    ),
  ];

  /// (baris, apakah kalimat bukti / distabilo)
  static const transcript = <(String, bool)>[
    ('Andi: Good afternoon, Ms Mira.', false),
    ('Mira: Hello, Andi. What would you like?', false),
    ('Andi: I\u2019d like a chicken sandwich, please.', true),
    ('Mira: Of course. It costs fifteen thousand rupiah.', true),
    ('Andi: Here you are. Is there a free table?', false),
    ('Mira: Yes, there is one near the window.', false),
    ('Andi: Thank you. I\u2019ll sit near the window.', true),
  ];
}

