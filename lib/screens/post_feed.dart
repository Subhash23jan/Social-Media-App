import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar/Models/user_model.dart';
import 'package:tab_bar/pages/messege_page.dart';
import 'package:tab_bar/providers/user_provider.dart';
import 'package:tab_bar/widgets/post_card.dart';

class PostFeedScreen extends StatefulWidget {
  const PostFeedScreen({Key? key}) : super(key: key);

  @override
  State<PostFeedScreen> createState() => _PostFeedScreenState();
}

class _PostFeedScreenState extends State<PostFeedScreen> {

  refresh(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    try{
      UserModel user=Provider.of<UserProvider>(context).getUser;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: false,
          title: SvgPicture.asset('lib/assets/ic_instagram.svg',color: Colors.white,),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 05),
                child: IconButton(onPressed: ()=>Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  MessageScreen(userId: user.uid,),)),
                    icon:const Icon(FontAwesomeIcons.facebookMessenger,color: Colors.white70,)))
          ],
        ),
        body:RefreshIndicator(
          onRefresh:()=>Future.delayed(const Duration(seconds: 1),refresh()),
          child: StreamBuilder(
            stream:FirebaseFirestore.instance.collection("posts").orderBy('dateTime',descending: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index) {
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
                  try{
                    return PostCard(snap: snapshot.data!.docs[index].data(),user: user,);
                  }catch(e)
                  {
                    return Container(color: Colors.white,);
                  }
                },
              );
            },

          ),
        ),
      );
    }catch(e)
    {
      return Container(color: Colors.white,);
    }

  }

}
