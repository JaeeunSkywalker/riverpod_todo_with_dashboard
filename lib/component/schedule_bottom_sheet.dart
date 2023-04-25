import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_todo_with_dashboard/component/custom_text_field.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';
import 'package:riverpod_todo_with_dashboard/database/drift_database.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet({
    this.scheduleId,
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
//여러 개의 위젯을 동시에 관리하기 위해 GlobalKey가 사용됨.
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;
  int? selectedEmojiId;

  @override
  Widget build(BuildContext context) {
    //현재 올라온 키보드 사이즈 알 수 있음
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        //이거 적용하면 그 전에 포커스 되어 있던 곳에서 포커스를 없앨 수 있다.
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId == null
              ? null
              : GetIt.I<LocalDatabase>().getScheduleById(widget.scheduleId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('스케줄을 불러올 수 없습니다.'),
              );
            }

            //FutureBuilder가 처음 실행됐고
            //로딩 중일 때
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    indigo200!,
                  ),
                ),
              );
            }

            //Future가 실행이 되고
            //값이 있는데 단 한 번도 startTime이 세팅되지 않았을 때
            //db 통해서 초기화해 준다.
            if (snapshot.hasData && startTime == null) {
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              content = snapshot.data!.content;
              selectedEmojiId = snapshot.data!.emojiId;
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.5 + bottomInset,
              color: white,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 16.0,
                  ),
                  child: Form(
                    //이 Form을 가지고 TextFormField 조작한다.
                    key: formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Time(
                          onStartSaved: (String? val) {
                            startTime = int.parse(val!);
                          },
                          onEndSaved: (String? val) {
                            endTime = int.parse(val!);
                          },
                          startInitialValue: startTime?.toString() ?? '',
                          endInitialValue: endTime?.toString() ?? '',
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        _Content(
                          onSaved: (String? val) {
                            content = val;
                          },
                          initialValue: content ?? '',
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        //null check option 없는 ver.
                        // FutureBuilder<List<CategoryEmoji>>(
                        //   future: GetIt.I<LocalDatabase>().getCategoryEmojis(),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasData &&
                        //         selectedEmojiId == null &&
                        //         snapshot.data!.isNotEmpty &&
                        //         ) {
                        //       selectedEmojiId = snapshot.data![0].id;
                        //     }

                        //     // ignore: prefer_const_constructors
                        //     return _EmojiPicker(
                        //       emojis: snapshot.hasData ? snapshot.data! : [],
                        //       selectedEmojiId: selectedEmojiId!,
                        //     );
                        //   },
                        // ),
                        FutureBuilder<List<CategoryEmoji>>(
                          future: GetIt.I<LocalDatabase>().getCategoryEmojis(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && selectedEmojiId == null) {
                              selectedEmojiId = snapshot.data![0].id;
                            }

                            return _EmojiPicker(
                              emojis: snapshot.data ?? [], // null 체크를 함께 수행
                              selectedEmojiId: selectedEmojiId ?? 0,
                              emojiIdSetter: (int id) {
                                setState(() {
                                  selectedEmojiId = id;
                                });
                              },
                            );
                          },
                        ),

                        const SizedBox(
                          height: 6.0,
                        ),
                        _SaveButton(
                          onPressed: onSavePressed,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void onSavePressed() async {
    //formKey는 생성을 했는데
    //form 위젯과 결합을 안 했을 때.
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (widget.scheduleId == null) {
        await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            emojiId: Value(selectedEmojiId!),
          ),
        );
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            emojiId: Value(selectedEmojiId!),
          ),
        );
      }

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      // ignore: avoid_print
      print('에러가 있습니다.');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String>? onStartSaved;
  final FormFieldSetter<String>? onEndSaved;
  final String startInitialValue;
  final String endInitialValue;

  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.startInitialValue,
    required this.endInitialValue,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작 시간',
            isTime: true,
            onSaved: onStartSaved!,
            initialValue: startInitialValue,
          ),
        ),
        const SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: CustomTextField(
            label: '마감 시간',
            isTime: true,
            onSaved: onEndSaved!,
            initialValue: endInitialValue,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Content({
    required this.onSaved,
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}

//이모지 선택이 가능하게 하기 위해 setter를 만듦
typedef EmojiIdSetter = void Function(int id);

class _EmojiPicker extends StatelessWidget {
  final List<CategoryEmoji> emojis;
  final int? selectedEmojiId;
  final EmojiIdSetter emojiIdSetter;

  const _EmojiPicker({
    required this.emojiIdSetter,
    required this.emojis,
    required this.selectedEmojiId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: emojis
          .map(
            (e) => GestureDetector(
              onTap: () {
                emojiIdSetter(e.id);
              },
              child: renderEmoji(e, selectedEmojiId == e.id),
            ),
          )
          .toList(),
    );
  }

  Widget renderEmoji(CategoryEmoji value, bool isSelected) {
    return Container(
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(
                color: black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      width: 30.0,
      height: 16.0,
      child: Center(
        child: Text(
          style: const TextStyle(),
          value.hexCode,
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SaveButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: indigo200,
            ),
            child: const Text('저장'),
          ),
        ),
      ],
    );
  }
}
