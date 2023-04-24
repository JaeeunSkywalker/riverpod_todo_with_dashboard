import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:intl/intl.dart';

import '../../consts/colors.dart';

class OnDaySelectedPage extends StatefulWidget {
  final DateTime? selectedDay;

  const OnDaySelectedPage({
    this.selectedDay,
    Key? key,
  }) : super(key: key);

  @override
  State<OnDaySelectedPage> createState() => _OnDaySelectedPageState();
}

class _OnDaySelectedPageState extends State<OnDaySelectedPage> {
  int startHour = 0;
  int endHour = 1;
  String selectedTime = '';
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        body: Column(
          children: [
            Center(
              child: Text(
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'SingleDay',
                ),
                widget.selectedDay!.toString().substring(0, 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: indigo200,
      onPressed: () {
        showInformationDialog(context);
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Future<void> showInformationDialog(BuildContext context) async {
    //0.7, 0.6
    double screenWidth = MediaQuery.of(context).size.width * 0.8;
    double screenHeight = MediaQuery.of(context).size.height * 0.8;
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            //이거 적용하면 그 전에 포커스 되어 있던 곳에서 포커스를 없앨 수 있다.
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                insetPadding: const EdgeInsets.all(20),
                content: SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.4,
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          controller: titleController,
                          cursorColor: indigo200,
                          validator: (value) {
                            return value!.isNotEmpty ? null : '';
                          },
                          decoration: InputDecoration(
                            hintText: "할 일",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: indigo200!,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: indigo200!,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: indigo200!,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: indigo200!,
                                    ),
                                  ),
                                ),
                                readOnly: true,
                                controller:
                                    TextEditingController(text: selectedTime),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: indigo200,
                              ),
                              onPressed: () {
                                timePickerDialog().then((value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedTime = value;
                                    });
                                  }
                                });
                              },
                              child: const Icon(Icons.access_time_outlined),
                            )
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: contentController,
                            cursorColor: indigo200,
                            keyboardType: TextInputType.multiline,
                            expands: true,
                            maxLines: null,
                            maxLength: 100,
                            minLines: null,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: indigo200!,
                                ),
                              ),
                              hintText:
                                  "내용을 적어 주세요.\n끝에 '#키워드'를 입력하면\n리포트에서 통계로 볼 수 있어요.",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: indigo200!,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        '저장',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    onTap: () async {
                      // 파이어스토어에 데이터 저장하기
                      if (titleController.text != '' && selectedTime != '') {
                        await FirebaseFirestore.instance
                            .collection('users') // users 컬렉션
                            .doc(FirebaseAuth
                                .instance.currentUser!.uid) // 현재 사용자 uid로 문서 식별
                            .collection('dates') // 날짜로 분류한 컬렉션
                            .doc(widget.selectedDay.toString())
                            .collection('indexs')
                            .doc(selectedTime) // 날짜를 문자열로 변환하여 문서 식별
                            .set({
                          'title': titleController.text,
                          'selectedTime': selectedTime.toString(),
                          'content': contentController.text,
                        });
                        titleController.text = '';
                        selectedTime = '';
                        contentController.text = '';
                        startHour = 0;
                        endHour = 1;
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('오류'),
                              content:
                                  const Text('할 일과 시간을 입력해 주시면 저장할 수 있습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    '확인',
                                    style: TextStyle(
                                      color: black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    onTap: () async {
                      titleController.text = '';
                      selectedTime = '';
                      contentController.text = '';
                      startHour = 0;
                      endHour = 1;
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<dynamic> timePickerDialog() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '시간 선택',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButton<int>(
                    value: startHour,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          startHour = newValue;
                        });
                      }
                    },
                    items: List.generate(
                      24,
                      (int index) => DropdownMenuItem(
                        value: index,
                        child: Text('$index시'),
                      ),
                    ),
                  );
                },
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButton<int>(
                    value: endHour,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          endHour = newValue;
                        });
                      }
                    },
                    items: List.generate(
                      24,
                      (int index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}시'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(
                  color: black,
                ),
              ),
              onPressed: () {
                // 확인 버튼 클릭 시 동작
                if (endHour - startHour > 0) {
                  selectedTime = '$startHour시 ~ $endHour시';
                  // 시간 값을 TextFormField 위젯에 반영

                  Navigator.of(context).pop(selectedTime);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('오류'),
                        content: const Text('종료 시간이 시작 시간보다 커야 합니다.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              '확인',
                              style: TextStyle(
                                color: black,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            TextButton(
              child: const Text(
                '취소',
                style: TextStyle(
                  color: black,
                ),
              ),
              onPressed: () {
                // 취소 버튼 클릭 시 동작
                startHour = 0;
                endHour = 1;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
