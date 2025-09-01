import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ar_page.dart'; // halaman AR
import 'quiz_detail_page.dart';

class EnsiklopediaDetailPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String content;

  const EnsiklopediaDetailPage({
    super.key,
    required this.title,
    required this.imagePath,
    required this.content,
  });

  @override
  State<EnsiklopediaDetailPage> createState() => _EnsiklopediaDetailPageState();
}

class _EnsiklopediaDetailPageState extends State<EnsiklopediaDetailPage> {
  void _onScanPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ArPage()),
    );
  }

  void _onQuizPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (_) => QuizDetailPage(
            title: widget.title, // ⬅️ kirim judul ensiklopedia
        ),
        ),
    );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDD44), // kuning
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Header ===
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/left.svg",
                      width: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.dynaPuff(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // === Gambar (4:3 ratio) ===
              Center(
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // === Artikel scrollable ===
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.white,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor: MaterialStateProperty.all(
                              const Color(0xFF00EB91)), // hijau muda
                          trackColor: MaterialStateProperty.all(
                              const Color(0xFF00BD74)), // hijau tua
                        ),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        radius: const Radius.circular(8),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            widget.content,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.dynaPuff(
                              fontSize: 16,
                              height: 1.8,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // === Tombol SCAN AR dan QUIZ ===
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tombol Scan AR
                    GestureDetector(
                      onTap: _onScanPressed,
                      child: Container(
                        width: 140,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF1D3DA0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "SCAN AR",
                          style: GoogleFonts.dynaPuff(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Tombol Quiz
                    GestureDetector(
                      onTap: _onQuizPressed,
                      child: Container(
                        width: 140,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF95ABFE),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "QUIZ",
                          style: GoogleFonts.dynaPuff(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
