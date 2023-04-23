import 'package:flutter/material.dart';

import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:riverpod_todo_with_dashboard/services/auth_service.dart';

import '../non_login_main.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({Key? key}) : super(key: key);

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Button(
          buttonMessage: '구글 로그인',
          onPressed: () {
            AuthService().signInWithGoogle();
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
        _Button(
          buttonMessage: '회원가입(및 로그인) 없이 사용하기',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NonLoginMain(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final String buttonMessage;
  final VoidCallback onPressed;

  const _Button({
    Key? key,
    required this.buttonMessage,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.5,
          ),
        ),
        height: 70,
        child: Text(
          buttonMessage,
          style: const TextStyle(
            fontSize: 20.0,
            color: black,
          ),
        ),
      ),
    );
  }
}
