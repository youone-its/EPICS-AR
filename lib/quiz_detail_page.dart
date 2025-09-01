import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'ar_page.dart';

class QuizDetailPage extends StatefulWidget {
  final String title;
  const QuizDetailPage({super.key, required this.title});

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  List<dynamic> questions = [];
  int currentIndex = 0;
  String? selectedAnswer;
  bool answered = false;
  int score = 0; // ✅ skor disimpan di state

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    String jsonString =
        await DefaultAssetBundle.of(context).loadString("assets/quiz.json");
    Map<String, dynamic> jsonData = json.decode(jsonString);

    setState(() {
      questions = jsonData[widget.title] ?? [];
    });
  }

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      // Quiz selesai → pakai dialog custom
      _showFinishDialog(context, widget.title);
    }
  }

  void _showFinishDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2), // abu muda
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // semua isi ke kiri
                  children: [
                    // Judul
                    Text(
                      "SELESAI!",
                      style: GoogleFonts.dynaPuff(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Deskripsi
                    Text(
                      "Kuis $title\nSudah Selesai",
                      style: GoogleFonts.dynaPuff(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Nilai
                    Text(
                      "Nilai: $score / ${questions.length}",
                      style: GoogleFonts.dynaPuff(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol OK align kiri
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCAEB78),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "OK",
                          style: GoogleFonts.dynaPuff(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // Maskot daun di pojok kanan bawah (besar & crop)
              Positioned(
                right: -40,
                bottom: -120,
                child: SvgPicture.asset(
                  "assets/daun.svg",
                  height: 360,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFCAEB78),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentIndex];
    final options = question["options"] as List<dynamic>;
    final correctAnswer = question["answer"];

    return Scaffold(
      backgroundColor: const Color(0xFFCAEB78),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                    // Tombol back
                    IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),

                    // Judul "Quiz"
                    Expanded(
                    child: Text(
                        "Quiz",
                        style: GoogleFonts.dynaPuff(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        ),
                    ),
                    ),

                    // Icon QR code di kanan
                    IconButton(
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
                    onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ArPage()),
                        );
                    },
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Progress
              Text(
                "${currentIndex + 1} dari ${questions.length}",
                style: GoogleFonts.dynaPuff(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (currentIndex + 1) / questions.length,
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 20),

              // Question
              Text(
                question["question"],
                style: GoogleFonts.dynaPuff(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Options
              ...options.map((opt) {
                bool isCorrect = opt == correctAnswer;
                bool isSelected = opt == selectedAnswer;

                Color bgColor = Colors.white;
                if (answered && isSelected) {
                  bgColor = isCorrect
                      ? const Color(0xFFDCFFDE) // benar
                      : const Color(0xFFFFBBB9); // salah
                }

                return GestureDetector(
                  onTap: () {
                    if (!answered) {
                      setState(() {
                        selectedAnswer = opt;
                        answered = true;
                        if (isCorrect) score++; // ✅ update skor
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            opt,
                            style: GoogleFonts.dynaPuff(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (answered && isSelected)
                          Icon(
                            isCorrect ? Icons.check : Icons.close,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                      ],
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Next Button
              if (answered)
                GestureDetector(
                  onTap: _nextQuestion,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00EB91),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Lanjut",
                        style: GoogleFonts.dynaPuff(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
