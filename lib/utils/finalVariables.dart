
import 'package:flutter/material.dart';
import 'package:tab_bar/pages/search_page.dart';
import 'package:tab_bar/screens/common_profile_Screen.dart';
import 'package:tab_bar/screens/post_feed.dart';

import '../pages/add_post.dart';
import '../pages/profile_page.dart';

List<Widget> screens=[   const PostFeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(child: Text("notifications",style:TextStyle(color: Colors.white),)),
  const CommonScreen(),];
