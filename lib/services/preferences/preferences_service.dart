import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collevo_teacher/services/auth/auth_service.dart';
import 'package:collevo_teacher/services/auth/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> getSharedPreferences() async {
    return _getSharedPreferencesInstance();
  }

  Future<void> setUserDetails(String email) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs.first.data() as Map<String, dynamic>?;
      if (userData != null) {
        final userName = userData['name'] as String?;
        final batch = userData['assigned_batch'] as String?;
        final teacherId = userData['uid'] as String?;

        final preferences = await SharedPreferences.getInstance();
        preferences.setString('email', email.trim());
        preferences.setString('name', userName!.trim());
        preferences.setString('batch', batch!.trim());
        preferences.setString('uid', teacherId ?? '');

        return;
      }
    }
  }

  Future<void> clearUserDetails() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('email');
    preferences.remove('name');
    preferences.remove('batch');
    preferences.remove('uid');
  }

  Future<String?> getEmail() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('email');
  }

  Future<String?> getName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('name');
  }

  Future<String?> getUid() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('uid');
  }

  Future<String?> getBatch() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('batch');
  }

  // Future<String?> getDept() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   return preferences.getString('dept');
  // }

  Future<void> setUid() async {
    final preferences = await _getSharedPreferencesInstance();
    final AuthService authService = AuthService.firebase();
    final AuthUser? currentUser = authService.currentUser;

    preferences.setString('uid', currentUser?.id ?? '');
  }
}
