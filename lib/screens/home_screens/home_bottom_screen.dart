import 'package:flutter/material.dart';

import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:riverpod_todo_with_dashboard/screens/non_login_screens/non_login_main.dart';

class HomeBottomScreen extends StatefulWidget {
  const HomeBottomScreen({super.key});

  @override
  State<HomeBottomScreen> createState() => _HomeBottomScreenState();
}

class _HomeBottomScreenState extends State<HomeBottomScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Button(
          //TODO 1번: 구글 로그인 구현
          buttonMessage: '구글 로그인 들어갈 자리',
          onPressed: () {},
        ),
        const SizedBox(
          height: 20.0,
        ),
        _Button(
          buttonMessage: '회원가입(및 로그인) 없이 사용하기',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NonLoginMain(),
            ));
          },
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class _Button extends StatelessWidget {
  String buttonMessage = '';
  VoidCallback onPressed;
  _Button({
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
        )),
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
