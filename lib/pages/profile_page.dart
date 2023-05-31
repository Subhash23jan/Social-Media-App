

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    UserModel? user=Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:user.uid==widget.uid?AppBar(
        toolbarHeight: 1,
        backgroundColor: Colors.black,
      ):AppBar(
        backgroundColor: Colors.black,
        toolbarHeight:kToolbarHeight-20,
        leading:const Text(" ",style: TextStyle(color: Colors.black),),
        actions: [TextButton(onPressed: ()=>Navigator.pop(context), child:Text("back",style:GoogleFonts.aBeeZee(color:Colors.blue,fontSize: 18)))],
      ),
      body:ListView(
        children: [
          FutureBuilder(
            future:FirebaseFirestore.instance.collection("users").where('uid',isEqualTo:widget.uid).get(),
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
                          InkWell(onTap:(){},child: Text("posts",style:GoogleFonts.aBeeZee(color:Colors.white70,fontSize: 18))),
                        ],
                      ),
                      Column(
                        children: [
                          Text("${snap['following'].length}",style:GoogleFonts.aBeeZee(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10,),
                          InkWell(onTap:(){},child: Text("following",style:GoogleFonts.aBeeZee(color:Colors.white70,fontSize: 18))),
                        ],
                      ),
                      Column(
                        children: [
                          Text("${snap['followers'].length}",style:GoogleFonts.aBeeZee(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10,),
                          InkWell(onTap:(){},child: Text("followers",style:GoogleFonts.aBeeZee(color:Colors.white70,fontSize: 18))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(snap['bio'],style:GoogleFonts.damion(color:Colors.white,fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.only(left: 68.0),
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
                          width: 200,
                          child: widget.uid==user.uid?TextButton(onPressed: (){}, child:  Text("Edit Profile",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15), )):
                          TextButton(onPressed: (){}, child:  Text("Follow",style: GoogleFonts.aBeeZee(color: Colors.blue,fontSize: 15), )),
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
                    }
                ),
              );
            },)
        ],
      ),
    );
  }
}