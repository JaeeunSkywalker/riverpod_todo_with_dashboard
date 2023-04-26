import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices extends StatelessWidget {
  const FirebaseServices({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
