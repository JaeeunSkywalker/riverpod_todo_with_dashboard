import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices extends StatelessWidget {
  const FirebaseServices({super.key});

  //바 차트 위한 메서드
  Future<int> getIsDoneTrueDaysFromMonth(String month) async {
    final now = DateTime.now();
    final year = now.year;
    int count = 0;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('dates')
        .where(FieldPath.documentId,
            isGreaterThanOrEqualTo: '$year-$month-01',
            isLessThanOrEqualTo: '$year-$month-31')
        .get();

    for (var doc in querySnapshot.docs) {
      final innerQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('dates')
          .doc(doc.id)
          .collection('indexes')
          .get();

      for (DocumentSnapshot indexesDoc in innerQuerySnapshot.docs) {
        if (indexesDoc.get('isDone') == true) {
          count++;
          break;
        }
      }
    }

    return count;
  }

//파이 차트 위한 메서드
  Future<Map<String, int>> getKeywordsFromYear() async {
    final now = DateTime.now();
    final year = now.year;
    int study = 0;
    int workout = 0;
    int diet = 0;
    int work = 0;
    int hobby = 0;
    int meditate = 0;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('dates')
        .where(FieldPath.documentId,
            isGreaterThanOrEqualTo: '$year-01-01',
            isLessThanOrEqualTo: '$year-12-31')
        .get();

    for (var doc in querySnapshot.docs) {
      final innerQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('dates')
          .doc(doc.id)
          .collection('indexes')
          .get();

      for (DocumentSnapshot indexesDoc in innerQuerySnapshot.docs) {
        String content = indexesDoc.get('content');
        if (content.contains('#공부')) {
          study++;
          break;
        }
        if (content.contains('#운동')) {
          workout++;
          break;
        }
        if (content.contains('#식단')) {
          diet++;
          break;
        }
        if (content.contains('#업무')) {
          work++;
          break;
        }
        if (content.contains('#취미')) {
          hobby++;
          break;
        }
        if (content.contains('#명상')) {
          meditate++;
          break;
        }
      }
    }

    return {
      '공부': study,
      '운동': workout,
      '식단': diet,
      '업무': work,
      '취미': hobby,
      '명상': meditate,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
