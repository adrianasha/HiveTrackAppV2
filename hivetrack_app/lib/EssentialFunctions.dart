import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

String generateCustomId(int length, bool includeLowercase, bool numberOnly) {
  const charsWithLowercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  const charsWithoutLowercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const charsNumbersOnly = '0123456789';

  String chars = numberOnly ? charsNumbersOnly : (includeLowercase ? charsWithLowercase : charsWithoutLowercase);

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
      try {
        DocumentSnapshot snapshot = await firestore.collection(collection).doc(uid).get();

        if (snapshot.exists) {
          return {
            'parent_name': collection,
            'user_data': snapshot.data(),
          };
        }
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          print('Permission denied for collection $collection. Skipping...');
        } else {
          print('An unexpected error occurred in collection $collection: ${e.message}');
        }
        continue;
      }
    }

    throw Exception('User not found in any of the collections');
  } on FirebaseException catch (e) {
    if (e.code == 'permission-denied') {
      print('Permission denied. Ensure Firestore rules are configured correctly.');
    } else {
      print('An unexpected error occurred: ${e.message}');
    }
    return {};
  } catch (e) {
    print('Error fetching user data: $e');
    return {};
  }
}

Future<Map<String, dynamic>> getAllUnverifiedUsersByCID(String companyId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<String> collections = ['Agent', 'Dropship_Agent'];
    Map<String, dynamic> unverifiedUsersMap = {};
    for (String collection in collections) {
      QuerySnapshot querySnapshot = await firestore
          .collection(collection)
          .where('verified', isEqualTo: false)
          .where('company_id', isEqualTo: companyId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        unverifiedUsersMap[collection] = {};
        for (var doc in querySnapshot.docs) {
          unverifiedUsersMap[collection][doc.id] = doc.data();
        }
      }
    }

    return unverifiedUsersMap;
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

Future<Map<String, dynamic>> getAllVerifiedUsersByCID(String companyId, int Mode) async {
  Map<int, dynamic> collections = { 0:'Agent', 1:'Dropship_Agent' };
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collection = collections[Mode];

    Map<String, dynamic> unverifiedUsersMap = {};
    QuerySnapshot querySnapshot = await firestore
        .collection(collection)
        .where('verified', isEqualTo: true)
        .where('company_id', isEqualTo: companyId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        unverifiedUsersMap[doc.id] = doc.data();
      }
    }

    return unverifiedUsersMap;
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

Future<String?> getCurrentAuthUserId() async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  } catch (e) {
    print('Error getting current user UID: $e');
    return null;
  }
}

Future<Map<String, String>> getCityAndRegion(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location location = locations.first;

      // Use reverse geocoding to get address components
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String city = place.locality ?? '';
        String region = place.administrativeArea ?? '';

        return {'city': city, 'region': region};
      } else {
        throw Exception('No placemarks found for the given coordinates.');
      }
    } else {
      throw Exception('No locations found for the given address.');
    }
  } catch (e) {
    throw Exception('Error retrieving city and region: $e');
  }
}