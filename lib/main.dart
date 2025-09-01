import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// import pages
import 'ensiklopedia_page.dart';
import 'ar_page.dart';
import 'quiz_page.dart';
import 'help_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Epicsar",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

/// ==================
/// SPLASH SCREEN
/// ==================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _logoOpacity;

  late AnimationController _moveController;
  late Animation<Alignment> _logoAnimation;

  late AnimationController _leafController;
  late Animation<Offset> _leafOffset;

  @override
  void initState() {
    super.initState();

    // Fade in logo
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _opacityController, curve: Curves.easeIn),
    );
    _opacityController.forward();

    // Glide logo ke atas
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoAnimation = AlignmentTween(
      begin: Alignment.center,
      end: Alignment.topCenter,
    ).animate(
      CurvedAnimation(parent: _moveController, curve: Curves.easeOutBack),
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      _moveController.forward();
    });

    // Animasi daun
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _leafOffset = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, 2.5),
          end: const Offset(0, -0.3),
        ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, -0.3),
          end: const Offset(0, 0.3),
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 30,
      ),
    ]).animate(_leafController);
    Future.delayed(const Duration(milliseconds: 2000), () {
      _leafController.forward();
    });

    // pindah ke HomePage
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _moveController.dispose();
    _leafController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDD44),
      body: Stack(
        children: [
          // Daun
          SlideTransition(
            position: _leafOffset,
            child: SvgPicture.asset(
              "assets/daun.svg",
              width: 2000,
              height: 2000,
            ),
          ),
          // Logo
          AnimatedBuilder(
            animation: _moveController,
            builder: (context, child) {
              return Align(
                alignment: _moveController.isAnimating || _moveController.isCompleted
                    ? _logoAnimation.value
                    : Alignment.center,
                child: FadeTransition(
                  opacity: _logoOpacity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: child,
                  ),
                ),
              );
            },
            child: SvgPicture.asset(
              "assets/epics.svg",
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}

/// ==================
/// HOME PAGE
/// ==================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Stack(
          children: [
            // background bawah
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                "assets/bottom.svg",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),

            // konten
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset("assets/epics-logo.svg", width: 80),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PopButton(
                          title: "Ensiklopedia",
                          color: const Color(0xFFCAEB78),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EnsiklopediaPage()),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        PopButton(
                          title: "AR",
                          color: const Color(0xFFF197E1),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ArPage()),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        PopButton(
                          title: "Quiz",
                          color: const Color(0xFF95ABFE),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const QuizPage()),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        PopButton(
                          title: "Help",
                          color: const Color(0xFF1D3DA0),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HelpPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ==================
/// POP BUTTON
/// ==================
class PopButton extends StatefulWidget {
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const PopButton({
    super.key,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  State<PopButton> createState() => _PopButtonState();
}

class _PopButtonState extends State<PopButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.05,
      value: 1.0,
      duration: const Duration(milliseconds: 150),
    );
  }

  void _popDown() => _controller.animateTo(0.95,
      duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  void _popUp() => _controller.animateTo(1.05,
      duration: const Duration(milliseconds: 150), curve: Curves.easeOutBack);
  void _popNormal() => _controller.animateTo(1.0,
      duration: const Duration(milliseconds: 150), curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _popUp(),
      onExit: (_) => _popNormal(),
      child: GestureDetector(
        onTapDown: (_) => _popDown(),
        onTapUp: (_) {
          _popUp();
          if (widget.onTap != null) widget.onTap!();
        },
        onTapCancel: _popNormal,
        child: ScaleTransition(
          scale: _controller,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                widget.title,
                style: GoogleFonts.dynaPuff(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
