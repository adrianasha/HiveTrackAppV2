import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

String generateCustomId(int length, bool includeLowercase) {
  const charsWithLowercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  const charsWithoutLowercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  String chars = includeLowercase ? charsWithLowercase : charsWithoutLowercase;

  Random rand = Random();
  StringBuffer sb = StringBuffer();

  for (int i = 0; i < length; i++) {
    sb.write(chars[rand.nextInt(chars.length)]);
  }

  return sb.toString();
}

Future<Map<String, dynamic>> getUserDataWithParentName(String uid) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<String> collections = ['Agent', 'Company', 'Dropship_Agent'];

    for (String collection in collections) {
      DocumentSnapshot snapshot = await firestore.collection(collection).doc(uid).get();

      if (snapshot.exists) {
        return {
          'parent_name': collection,
          'user_data': snapshot.data(),
        };
      }
    }

    throw Exception('User not found in any of the collections');
  } on FirebaseException catch (e) {
    if (e.code == 'permission-denied') {
      print('Permission denied. Ensure Firestore rules are configured correctly.');
      // Notify the user about the permission issue
    } else {
      print('An unexpected error occurred: ${e.message}');
    }
    return {};
  } catch (e) {
    print('Error fetching user data: $e');
    return {};
  }
}