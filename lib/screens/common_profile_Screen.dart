

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar/Models/user_model.dart';
import 'package:tab_bar/pages/profile_page.dart';
import 'package:tab_bar/providers/user_provider.dart';

class CommonScreen extends StatefulWidget {
  const CommonScreen({Key? key}) : super(key: key);

  @override
  State<CommonScreen> createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel? user=Provider.of<UserProvider>(context).getUser;
    return ProfileScreen(uid: user.uid);
  }
}
