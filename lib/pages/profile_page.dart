

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar/FIreBase_operations/firestore_methods.dart';
import 'package:tab_bar/Models/user_model.dart';
import 'package:tab_bar/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key,required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int postCount=0,followersCount=0,followingCount=0;
  bool isLoading=true;
  var postSnap;
  bool isFollowing=false;
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }
  getUserInfo()async{
    try{
      postSnap=await FirebaseFirestore.instance.collection("posts").where('uid',isEqualTo:widget.uid).get();
      postCount=postSnap.docs.length;
    }catch(e)
    {
      isLoading=true;
      setState(() {});
    }
  }
  refresh() async{
    getUserInfo();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    UserModel user=Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:user.uid==widget.uid?AppBar(
        toolbarHeight:kToolbarHeight,
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () async{
            await FirebaseAuth.instance.signOut();
          }, icon: const Icon(Icons.power_settings_new_rounded))
        ],
      ):AppBar(
        backgroundColor: Colors.black,
        toolbarHeight:kToolbarHeight-20,
        leading:const Text(" ",style: TextStyle(color: Colors.black),),
        actions: [TextButton(onPressed: ()=>Navigator.pop(context), child:Text("back",style:GoogleFonts.aBeeZee(color:Colors.blue,fontSize: 18)))],
      ),
      body:RefreshIndicator(
        onRefresh:(){
          return Future.delayed(const Duration(seconds: 1),() => refresh(),);
        },
        child: ListView(
          children: [
            StreamBuilder (
              stream:FirebaseFirestore.instance.collection("users").where('uid',isEqualTo:widget.uid).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  {
                   return Stack(
                      alignment:Alignment.center,
                      children:  [
                        const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
                        Center(child: Text('searching...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white))),
                      ],
                    );
                  }
                DocumentSnapshot snap=(snapshot.data as dynamic).docs[0];
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundImage:NetworkImage(snap['profile_url']),
                          radius: 40,
                        ),
                        Column(
                          children: [
                            Text("$postCount",style:GoogleFonts.aBeeZee(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10,),
                            InkWell(onTap:(){},child: Text("posts",style:GoogleFonts.aBeeZee(color:Colors.white70,fontSize: 18,fontWeight: FontWeight.w700))),
                          ],
                        ),
                        Column(
                          children: [
                            Text("${snap['following'].length}",style:GoogleFonts.aBeeZee(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10,),
                            InkWell(onTap:(){
                              showConnections(snap['following'],false);
                            },child: Text("following",style:GoogleFonts.aBeeZee(color:Colors.white70,fontSize: 18,fontWeight: FontWeight.w700))),
                          ],
                        ),
                        Column(
                          children: [
                            Text("${snap['followers'].length}",style:GoogleFonts.aBeeZee(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10,),
                            InkWell(onTap:(){
                              showConnections(snap['followers'],true);
                            },child: Text("followers",style:GoogleFonts.aBeeZee(color:Colors.white70,fontSize: 18,fontWeight: FontWeight.w700))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(snap['bio'],style:GoogleFonts.firaSans(color:Colors.white,fontSize: 14)),
                        Padding(
                          padding: const EdgeInsets.only(left: 90.0),
                          child:Container(
                            height:40,
                            decoration: const BoxDecoration(
                                color: Colors.white10,

                                border:Border(
                                    top: BorderSide(color: Colors.white24),
                                    left: BorderSide(color: Colors.white24),
                                    right: BorderSide(color: Colors.white24),
                                    bottom: BorderSide(color: Colors.white24)
                                )
                            ),
                            width: 150,
                            child: widget.uid==user.uid?TextButton(onPressed: (){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('develop madovargoo kayro please!!🙏')));
                            }, child:  Text("Edit Profile",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15), )):
                            snap['followers'].contains(user.uid)?TextButton(onPressed: (){
                              FirestoreMethods().removeFollower(user.uid, widget.uid);
                              setState(() {
                                isFollowing=false;
                              });
                            },child:  Text("Unfollow",style: GoogleFonts.ubuntu(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.w500), )):TextButton(onPressed: (){
                              FirestoreMethods().addFollowers(user.uid, widget.uid);
                              setState(() {
                                isFollowing=true;
                              });
                            }, child:  Text("Follow",style: GoogleFonts.kanit(color: Colors.blue,fontSize: 15,fontWeight:FontWeight.w600), )),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15,),

                  ],
                );
              },),
            FutureBuilder(
              future:FirebaseFirestore.instance.collection("posts").where('uid',isEqualTo:widget.uid).get(),
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  reverse: true,
                  physics:const NeverScrollableScrollPhysics(),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: postCount,
                      padding:const EdgeInsets.all(5),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 5,),
                      itemBuilder: (context, index) {
                        while(snapshot.data==null)
                          {
                            return Stack(
                              alignment:Alignment.center,
                              children:  [
                                const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
                                Center(child: Text('refreshing...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white))),
                              ],
                            );
                          }
                        try{
                          DocumentSnapshot snap=(snapshot.data! as dynamic).docs[index];
                          return Image.network(snap['postUrl'],fit:BoxFit.cover,);
                        }catch(e)
                        {
                          showDialog(context: context, builder: (context) =>SimpleDialog(
                            alignment:Alignment.center,
                            title: Column(
                              children: [
                                const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
                                Center(child: Text('refreshing...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white))),
                              ],
                            ),
                            )
                          );
                        }
                        return null;
                      }
                  ),
                );
              },)
          ],
        ),
      ),
    );
  }

  void showConnections(List<dynamic>users, bool bool) async{
    List<UserModel>followers=[];
    if(bool) {
      followers=await getFollowers(users);
    }else{
      followers=await getFollowings(users);
    }
    if(context.mounted){
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        builder: (context) => ListView.builder (
          itemCount:users.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:NetworkImage(followers[index].profileUrl),
                  ),
                  const SizedBox(width: 20,),
                  InkWell(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(uid: followers[index].uid),));
                      },
                      child: Text(followers[index].name,style:GoogleFonts.aBeeZee(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),))
                ],
              ),
            );
          },),
      );
    }


  }

  Future<List<UserModel>> getFollowers(List<dynamic> users)async {
    List<UserModel>list=[];
    for(int i=0;i<users.length;i++ )
      {
        QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("users").where('uid',isEqualTo: users[i]).limit(1).get();
        List<DocumentSnapshot> documentSnapshot=snapshot.docs;
        list.add(UserModel.fromSnap(documentSnapshot[0]));
      }
    return list;
  }

  Future<List<UserModel>> getFollowings(List<dynamic> users)async {
    List<UserModel>list=[];
    for(int i=0;i<users.length;i++ )
    {
      QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("users").where('uid',isEqualTo: users[i]).limit(1).get();
      List<DocumentSnapshot> documentSnapshot=snapshot.docs;
      list.add(UserModel.fromSnap(documentSnapshot[0]));
    }
    return list;
  }
}