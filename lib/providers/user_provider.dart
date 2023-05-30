
import 'package:flutter/cupertino.dart';
import 'package:tab_bar/FIreBase_operations/firebase_auth_methods.dart';
import 'package:tab_bar/Models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  final FirebaseAuthMethods _authMethods=FirebaseAuthMethods();
  UserModel get getUser=> _userModel!;

  Future<void>refreshUser() async{
   UserModel userModel=await _authMethods.getUserDetails();
   _userModel=userModel;
    notifyListeners();
  }
}