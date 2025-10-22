import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String ocrText;

  const ResultScreen({super.key, required this.ocrText});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initTts().then((_) {
      _speakText(); // ✅ otomatis membaca hasil OCR saat halaman dibuka
    });
  }

  /// Inisialisasi Flutter TTS
  Future<void> _initTts() async {
    await flutterTts.setLanguage("id-ID"); // Bahasa Indonesia
    await flutterTts.setSpeechRate(0.5); // Kecepatan bicara sedang
  }

  @override
  void dispose() {
    flutterTts.stop(); // hentikan TTS saat halaman ditutup
    super.dispose();
  }

  /// Fungsi untuk membaca teks OCR
  Future<void> _speakText() async {
    if (widget.ocrText.isNotEmpty) {
      await flutterTts.speak(widget.ocrText);
    } else {
      await flutterTts.speak("Tidak ada teks ditemukan.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil OCR')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SelectableText(
            widget.ocrText.isEmpty
                ? 'Tidak ada teks ditemukan.'
                : widget.ocrText,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tombol untuk membaca teks
          FloatingActionButton(
            heroTag: 'ttsButton',
            onPressed: _speakText,
            tooltip: 'Baca Teks',
            child: const Icon(Icons.volume_up),
          ),
          const SizedBox(height: 10),
          // Tombol kembali ke Home
          FloatingActionButton(
            heroTag: 'homeButton',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
            tooltip: 'Kembali ke Home',
            child: const Icon(Icons.home),
          ),
        ],
      ),
    );
  }
}
