// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseServices extends StatelessWidget {
//   const FirebaseServices({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 현재 년도와 월을 얻습니다.
//     final now = DateTime.now();
//     final year = now.year;
//     final month = now.month;

//     Future<int> getIsDoneTrueDaysFromMonth(int month) async {
//       // 파이어스토어 컬렉션에 대한 참조를 가져옵니다.
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection('dates')
//           .where('id', isGreaterThanOrEqualTo: '2023-04')
//           .where('id', isLessThanOrEqualTo: '2023-04\uf8ff')
//           .get()
//           .then((querySnapshot) {
//         // Do something with the query result.
//       });
//     }

//     return Container();
//   }
// }
