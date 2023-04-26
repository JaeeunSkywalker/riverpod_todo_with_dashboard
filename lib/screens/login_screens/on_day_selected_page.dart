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

  final textStyle = const TextStyle(
    fontFamily: 'SingleDay',
  );

  bool done = false;

  //파이어스토어에서 데이터를 가져와 보자!!!
  Future<List<String>> fetchDataFromFirebase() async {
    final List<String> data = [];

    try {
      //db instance 만들고
      final db = FirebaseFirestore.instance;

      //uid 받고
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final QuerySnapshot datesSnapshot =
          await db.collection('users').doc(uid).collection('dates').get();

      if (datesSnapshot.docs.isEmpty) {
        // ignore: avoid_print
        // print('datesSnapshot.docs is empty');
      } else {
        //각 날짜별 문서에 접근 중
        for (final dateDoc in datesSnapshot.docs) {
          // 각각의 dateDoc은 dates 컬렉션 아래의 한 문서를 나타냅니다.
          final String date = dateDoc.id;

          // 해당 날짜 문서에 속한 indexes 서브콜렉션 가져오기
          final QuerySnapshot indexesSnapshot = await db
              .collection('users')
              .doc(uid)
              .collection('dates')
              .doc(date)
              .collection('indexes')
              .get();

          for (final indexDoc in indexesSnapshot.docs) {
            // 각각의 indexDoc은 해당 날짜의 indexes 서브콜렉션에 속한 한 문서를 나타냅니다.
            final String index = indexDoc.id;
            // index 문서에서 필요한 데이터 가져오기
            final String title = indexDoc.get('title');
            final String selectedTime = indexDoc.get('selectedTime');
            final String content = indexDoc.get('content');
            final bool isDone = indexDoc.get('isDone');
            done = isDone;
            // 가져온 데이터를 사용하여 필요한 작업 수행
            // 가져온 데이터를 data 리스트에 추가

            data.add(
              '$date / $index: $title, $selectedTime, $content, $isDone',
            );
          }
        }
      }

      return data;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: renderFloatingActionButton(),
        body: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                style: textStyle.copyWith(
                  fontSize: 30.0,
                ),
                widget.selectedDay!.toString().substring(0, 10),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            FutureBuilder<List<String>>(
              future: fetchDataFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터를 가져오는 중일 때는 로딩 중인 상태를 보여줌
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      indigo200!,
                    ),
                  );
                } else if (snapshot.hasError) {
                  // 데이터 가져오기에 실패한 경우
                  return Text(
                    '데이터를 가져오지 못 했습니다.',
                    style: textStyle.copyWith(
                      fontSize: 20.0,
                    ),
                  );
                } else if (snapshot.data!.isEmpty || snapshot.data == null) {
                  // 가져온 데이터가 없는 경우
                  return Text(
                    '스케줄이 없습니다',
                    style: textStyle.copyWith(
                      fontSize: 20.0,
                    ),
                  );
                } else {
                  // 가져온 데이터가 있는 경우
                  final filteredData = snapshot.data!
                      .where(
                        (element) => element.contains(
                          widget.selectedDay.toString().substring(0, 10),
                        ),
                      )
                      .toList();

                  return Expanded(
                    child: filteredData.isEmpty
                        ? Text(
                            '스케줄이 없습니다',
                            style: textStyle.copyWith(fontSize: 22.0),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              List<String> checkboxValues = [];

                              checkboxValues = List.generate(
                                filteredData.length,
                                (i) => filteredData[i]
                                    .split(':')
                                    .last
                                    .split(',')
                                    .elementAt(3)
                                    .toString(),
                              );

                              return GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Dialog(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '할 일:\n${filteredData[index].split(':').last.split(',').elementAt(0).trim()}',
                                                      style: textStyle.copyWith(
                                                          fontSize: 22.0),
                                                    ),
                                                    Text(
                                                      '시간:\n${filteredData[index].split(':').last.split(',').elementAt(1).trim()}',
                                                      style: textStyle.copyWith(
                                                          fontSize: 22.0),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '내용:\n${filteredData[index].split(':').last.split(',').elementAt(2).trim()}',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize: 22.0),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .collection(
                                                                    'dates')
                                                                .doc(
                                                                  widget
                                                                      .selectedDay!
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                                )
                                                                .collection(
                                                                    'indexes')
                                                                .doc(
                                                                  filteredData[
                                                                          index]
                                                                      .split(
                                                                          ':')
                                                                      .last
                                                                      .split(
                                                                          ',')
                                                                      .elementAt(
                                                                          1)
                                                                      .trim(),
                                                                )
                                                                .delete();
                                                            //selectedTime 테스트
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            '삭제',
                                                            style: textStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        20.0),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: ListTile(
                                  title: Center(
                                    child: Column(
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              height: 100.0,
                                              width: 220.0,
                                              decoration: const BoxDecoration(
                                                color: white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 10.0,
                                                    spreadRadius: 1.0,
                                                    offset: Offset(
                                                      5.0,
                                                      5.0,
                                                    ),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    filteredData[index]
                                                        .split(':')
                                                        .last
                                                        .split(',')
                                                        .elementAt(0),
                                                    style: textStyle.copyWith(
                                                        fontSize: 22.0),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    filteredData[index]
                                                        .split(':')
                                                        .last
                                                        .split(',')
                                                        .elementAt(1),
                                                    style: textStyle.copyWith(
                                                        fontSize: 22.0),
                                                  ),
                                                  Text(
                                                    filteredData[index]
                                                        .split(':')
                                                        .last
                                                        .split(',')
                                                        .elementAt(2),
                                                    style: textStyle.copyWith(
                                                        fontSize: 22.0),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: -10.0,
                                              bottom: 10.0,
                                              child: Container(
                                                width: 40.0,
                                                height: 160.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: indigo200,
                                                ),
                                                child: Center(
                                                  child: StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            if (checkboxValues[
                                                                    index] ==
                                                                'true') {
                                                              checkboxValues[
                                                                      index] =
                                                                  'false';
                                                            } else {
                                                              checkboxValues[
                                                                      index] =
                                                                  'true';
                                                            }
                                                          });
                                                          checkboxValues[index] ==
                                                                  'true'
                                                              ? await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                                  .collection(
                                                                      'dates')
                                                                  .doc(widget
                                                                      .selectedDay!
                                                                      .toString()
                                                                      .substring(
                                                                          0, 10))
                                                                  .collection(
                                                                      'indexes')
                                                                  .doc(filteredData[index]
                                                                      .split(
                                                                          ':')
                                                                      .last
                                                                      .split(
                                                                          ',')
                                                                      .elementAt(
                                                                          1)
                                                                      .trim())
                                                                  .update(
                                                                      {"isDone": true})
                                                              : await FirebaseFirestore
                                                                  .instance
                                                                  .collection('users')
                                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                                  .collection('dates')
                                                                  .doc(widget.selectedDay!.toString().substring(0, 10))
                                                                  .collection('indexes')
                                                                  .doc(filteredData[index].split(':').last.split(',').elementAt(1).trim())
                                                                  .update({"isDone": false});
                                                        },
                                                        child: FutureBuilder<
                                                                List<String>>(
                                                            future:
                                                                fetchDataFromFirebase(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      indigo200!,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              return Icon(
                                                                Icons.check,
                                                                color: filteredData[index]
                                                                            .split(':')
                                                                            .last
                                                                            .split(',')
                                                                            .elementAt(3)
                                                                            .trim() ==
                                                                        'true'
                                                                    ? black
                                                                    : white,
                                                                size: 30.0,
                                                              );
                                                            }),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 18.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                }
              },
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
                insetPadding: const EdgeInsets.all(0),
                content: SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.45,
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          maxLength: 25,
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
                        const SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: contentController,
                            cursorColor: indigo200,
                            keyboardType: TextInputType.multiline,
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            maxLength: 100,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: indigo200!,
                                ),
                              ),
                              hintText:
                                  "#공부 #운동 #식단 #업무 #취미\n#명상 중 하나를 입력하면\n통계에 반영됩니다.",
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
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '저장',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    onTap: () async {
                      //파이어스토어에 데이터 저장하기
                      if (titleController.text != '' && selectedTime != '') {
                        // await FirebaseFirestore.instance
                        //     .collection('users') // users 컬렉션
                        //     .doc(FirebaseAuth
                        //         .instance.currentUser!.uid) // 현재 사용자 uid로 문서 식별
                        //     .collection('dates')
                        //     // 날짜로 분류한 컬렉션
                        //     .doc(
                        //       widget.selectedDay!.toString().substring(0, 10),
                        //     )
                        //     .set({"dummy": "dummy"});

                        await FirebaseFirestore.instance
                            .collection('users') // users 컬렉션
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({"dummy": "dummy"}); // 현재 사용자 uid로 문서 식별

                        await FirebaseFirestore.instance
                            .collection('users') // users 컬렉션
                            .doc(FirebaseAuth
                                .instance.currentUser!.uid) // 현재 사용자 uid로 문서 식별
                            .collection('dates')
                            // 날짜로 분류한 컬렉션
                            .doc(
                              widget.selectedDay!.toString().substring(0, 10),
                            )
                            .set({"dummy": "dummy"});

                        await FirebaseFirestore.instance
                            .collection('users') // users 컬렉션
                            .doc(FirebaseAuth
                                .instance.currentUser!.uid) // 현재 사용자 uid로 문서 식별
                            .collection('dates')
                            // 날짜로 분류한 컬렉션
                            .doc(
                              widget.selectedDay!.toString().substring(0, 10),
                            )
                            .collection('indexes')
                            .doc(selectedTime) // 시간을 문자열로 변환하여 문서 식별
                            .set({
                          'title': titleController.text,
                          'selectedTime': selectedTime,
                          'content': contentController.text,
                          'isDone': false,
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
                  const SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
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
                        child: Text('${index.toString().padLeft(2, '0')}시'),
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
                        child:
                            Text('${(index + 1).toString().padLeft(2, '0')}시'),
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
                  //selectedTime = '$startHour시 ~ $endHour시';
                  selectedTime =
                      '${startHour.toString().padLeft(2, '0')}시 ~ ${endHour.toString().padLeft(2, '0')}시';

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
