import 'package:best_inox/model/profile.dart';
// import 'package:best_inox/model/year.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier {
  static ProfileProvider? _instance;
  static ProfileProvider? get instance => _instance;
  static Future init(BuildContext context) async {
    _instance = Provider.of<ProfileProvider>(context, listen: false);
  }

  // List<Month>? _Months;
  // List<Year>? _Years;
  Profile? _profile;
  List<Profile>? _profileList;

  Future<Profile> getProfile(String id) async {
    Profile p = await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) {
      return Profile.fromJson(value.data(), value.id);
    });
    _profile = p;
    return p;
  }

  Profile? get profile => _profile;

  Future<Profile> setProfile(UserCredential user) async {
    final Profile p = Profile(
      id: user.user!.uid,
      role: "unkown",
      fullName: user.user?.displayName ?? "",
      email: user.user?.email ?? "",
    );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.user?.uid)
        .set(p.toJson());
    return p;
  }

  Future<List<Profile>?> getProfiles() async {
    List<Profile>? l = await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((value) {
      return value.docs.map((e) {
        return Profile.fromJson(e.data(), e.id);
      }).toList();
    });

    _profileList = l;
    return null;
  }

  List<Profile>? get profileList => _profileList;
}
