import 'package:flutter/material.dart';

class HomeMiddleScreen extends StatefulWidget {
  const HomeMiddleScreen({super.key});

  @override
  State<HomeMiddleScreen> createState() => _HomeMiddleScreenState();
}

class _HomeMiddleScreenState extends State<HomeMiddleScreen> {
  @override
  Widget build(BuildContext context) {
    return const BlinkingText(
      text: '회원가입 없이도 사용할 수 있지만\n로그인 후 사용하면\n활동 내역 리포트를 볼 수 있어요!',
    );
  }
}

//글자를 깜빡이게 하고 싶어서//
//에뮬에서 프리징을 게속 유발해 개발 시에는 끔
class BlinkingText extends StatefulWidget {
  final String text;

  const BlinkingText({super.key, required this.text});

  @override
  BlinkingTextState createState() => BlinkingTextState();
}

class BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _controller.value,
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
