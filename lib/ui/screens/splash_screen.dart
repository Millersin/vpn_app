import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../core/resources/colors.dart';
import '../../core/resources/environment.dart';
import '../components/custom_divider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _circleAnimations;
  double _progress = 0.0; // Прогресс загрузки

  @override
  void initState() {
    super.initState();

    // Инициализация контроллера анимации
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Настройка анимации для каждого круга (поочередная анимация)
    _circleAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.2 * index, 1.0, curve: Curves.easeInOut),
        ),
      );
    });

    _controller.repeat(reverse: true); // Анимация будет повторяться

    // Запускаем прогресс загрузки
    _startLoading();
  }
  void _startLoading() async {
    while (_progress < 1.0) {
      await Future.delayed(const Duration(milliseconds: 50)); // Имитация работы (например, задержка)
      setState(() {
        _progress += 0.038; // Увеличиваем прогресс на каждом шаге
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: primaryGradient, color: primaryColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/splash_img.webp',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: Stack(
                children: _buildCircles(), // Вставляем анимацию кругов
              ),
            ),
            // Полоса загрузки
            Positioned(
              top: 0.35 * MediaQuery.of(context).size.height - 4, // Располагаем ниже анимации кругов
              left: (MediaQuery.of(context).size.width - 320) / 2, // Центрируем полосу по горизонтали
              child: Column(
                children: [
                  Container(
                    width: 320,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: _progress * 320,  // Заполняем полосу в зависимости от прогресса
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFB143FF), Color(0xFF6A2899)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
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

  List<Widget> _buildCircles() {
    double radius = 30.0;
    double circleSize = 15.0;
    int totalCircles = 4;
    double angle = 2 * pi / totalCircles;

    List<Widget> circles = [];
    for (int i = 0; i < totalCircles; i++) {
      double xPos = radius * cos(i * angle);
      double yPos = radius * sin(i * angle);

      circles.add(
        Positioned(
          left: 0.5 * MediaQuery.of(context).size.width + xPos - (circleSize / 2),
          top: 0.25 * MediaQuery.of(context).size.height + yPos - (circleSize / 2),
          child: AnimatedBuilder(
            animation: _circleAnimations[i],
            builder: (context, child) {
              return Transform.scale(
                scale: _circleAnimations[i].value,
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF7E5AFF),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    return circles;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}