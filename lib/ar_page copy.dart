import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// import page tujuan
import 'quiz_page.dart';
import 'ensiklopedia_page.dart';

class ArPage extends StatefulWidget {
  const ArPage({super.key});

  @override
  State<ArPage> createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // === Kamera full screen ===
            SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: MobileScanner(
                controller: MobileScannerController(),
                onDetect: (capture) {
                  for (final barcode in capture.barcodes) {
                    debugPrint('Barcode: ${barcode.rawValue}');
                  }
                },
              ),
            ),

            // === Background biru header ===
            Container(
              width: screenWidth,
              height: 70,
              color: const Color(0xFF1D3DA0),
            ),

            // === Header isi (back + Scan text) ===
            Positioned(
              top: 16,
              left: 12,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/left.svg",
                      width: 20,
                      color: const Color(0xFFFFDD44),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Scan",
                    style: GoogleFonts.dynaPuff(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFDD44),
                    ),
                  ),
                ],
              ),
            ),

            // === Daun di kanan atas (top -30) ===
            Positioned(
              top: -120,
              right: -10,
              child: Transform.rotate(
                angle: 180 * 3.14159 / 180,
                child: SvgPicture.asset(
                  "assets/daun.svg",
                  width: 165,
                  height: 283,
                ),
              ),
            ),

            // === Tombol bawah ===
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Quiz
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QuizPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFDD44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                      ),
                      child: Text(
                        "Quiz",
                        style: GoogleFonts.dynaPuff(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol Ensiklopedia
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EnsiklopediaPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFDD44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                      ),
                      child: Text(
                        "Ensiklopedia",
                        style: GoogleFonts.dynaPuff(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
