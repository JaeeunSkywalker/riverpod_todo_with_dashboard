import 'package:flutter/material.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;
  final String emoji;

  const ScheduleCard(
      {required this.startTime,
      required this.endTime,
      required this.content,
      required this.emoji,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: CalendarPrimaryColor!,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(
                startTime: startTime,
                endTime: endTime,
              ),
              const SizedBox(width: 16.0),
              _Content(
                content: content,
              ),
              const SizedBox(width: 16.0),
              Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: _Category(
                    emoji: emoji,
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

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;
  const _Time({required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: CalendarPrimaryColor,
      fontSize: 16.0,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2, '0')}:00',
          style: textStyle,
        ),
        Text(
          '${endTime.toString().padLeft(2, '0')}:00',
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;
  const _Content({required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}

class _Category extends StatelessWidget {
  final String emoji;

  const _Category({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      width: 16.0,
      height: 16.0,
      child: Text(
        emoji,
        style: const TextStyle(
          fontSize: 25,
        ),
      ),
    );
  }
}
