


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tab_bar/Models/user_model.dart';
import 'package:tab_bar/pages/profile_page.dart';

import '../FIreBase_operations/firestore_methods.dart';
import '../widgets/message_card.dart';
import 'image_screen.dart';

class ChatScreen extends StatefulWidget {
  final UserModel sender,receiver;
   ChatScreen({Key? key, required this.sender, required this.receiver}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isDeleting=false;
  final TextEditingController messageController=TextEditingController();
  bool isSending=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:Colors.white,
        toolbarHeight: kToolbarHeight+8,
        elevation: 130,
        leading:Padding(
          padding: const EdgeInsets.only(top: 5,left: 5),
          child: InkWell(onTap:()=>Navigator.push(context,
                MaterialPageRoute(builder: (context) => ImageViewScreen(postUrl: widget.sender.profileUrl),)),
            child: CircleAvatar(
              radius:20,
              backgroundImage: NetworkImage(widget.receiver.profileUrl),
            ),
          ),
        ),
        title: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(uid: widget.receiver.uid),));
          },
            child: Text(widget.receiver.name,style:GoogleFonts.aBeeZee(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),)),
        actions: [
          TextButton(
              onPressed:(){
                      showDialog(context: context, builder: (context) => AlertDialog(
                       content:const Text("Do you want to erase all chat",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                        actions: [
                          TextButton( onPressed:()=> Navigator.pop(context),
                            child: const Text("No",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,),),),
                             TextButton(onPressed:() async {
                                      Navigator.pop(context);
                                  setState(() {isDeleting=true;});
                          String res= await FirestoreMethods().deleteChat(widget.sender.uid, widget.receiver.uid);
                           Future.delayed(const Duration(seconds: 3),()=>setState(() {
                                                    isDeleting=false;
                                          }),);
                           if(context.mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("ella delete agoytu kanla")));
                           }
                           },  child: const Text("Yes",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,),),
                             )
                        ],
                     ),);
              },
              child: Text("Clear",style:GoogleFonts.aBeeZee(color:Colors.blue,fontSize: 20))
          ),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child:Text("back",style:GoogleFonts.aBeeZee(color:Colors.black,fontSize: 20))),

        ],
      ),
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(5.0),
        child: SafeArea(
          maintainBottomViewPadding:true,
          left: true,
          right: true,
          child:Container(
            decoration: BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black)
            ),
            height: kToolbarHeight,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,left: 5),
            child: Row(
              children:  [
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child:TextField(
                      style:const TextStyle(color: Colors.black),
                      controller: messageController,
                      onSubmitted: (value) async {
                        if(messageController.text.isNotEmpty){
                          FirestoreMethods().sendMessage(messageController.text, widget.sender, widget.receiver);
                          messageController.clear();
                        }
                      },
                      decoration:  const InputDecoration(
                          border:InputBorder.none,
                      ),
                    )),
                TextButton(onPressed: ()  async {
                  if(messageController.text.isNotEmpty){
                    FirestoreMethods().sendMessage(messageController.text, widget.sender, widget.receiver);
                    messageController.clear();
                  }
                }, child:const Icon(Icons.send,color: Colors.black,),onFocusChange:(value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },)
                ,
              ],
            ),
          ),
        ),
      ),
      body:isDeleting? Stack(
        alignment:Alignment.center,
        children:  [
          const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
          Center(child: Text('deleting...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white))),
        ],
      ):StreamBuilder(
        stream:FirebaseFirestore.instance.collection("chats").doc(widget.sender.uid).collection(widget.receiver.uid).orderBy('dateTime').snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting)
            {
              return Stack(
                alignment:Alignment.center,
                children:  [
                  const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
                  Center(child: Text('updating...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white))),
                ],
              );
            }
          return ListView.builder(
            itemCount:snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              dynamic snap=snapshot.data?.docs[index].data();
              return snap['type']=='send'?Padding(
                padding: const EdgeInsets.only(top: 10.0,bottom: 5),
                child: Row(
                  children: [
                    Padding(
                      padding:const EdgeInsets.only(left:10,right: 50),
                      child: Container(
                        decoration:  const BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(18),bottomLeft: Radius.circular(18),bottomRight: Radius.circular(18)),
                            border: Border.symmetric(vertical: BorderSide.none,horizontal: BorderSide.none)
                        ),
                        alignment: Alignment.center,
                        constraints:const BoxConstraints(
                            minHeight: 50,
                            minWidth: 200,
                          maxWidth: 200,
                        ),
                        child:ShowMessage(content:snap['content'], dateTime: snap['dateTime'].toDate(),type: snap['type'],),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(DateFormat('hh:mm a').format(snap['dateTime'].toDate(),),style: const TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ):Padding(
                padding: const EdgeInsets.only(top: 10.0,bottom: 5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0,right: 40),
                      child: Text(DateFormat('hh:mm a').format(snap['dateTime'].toDate(),),style: const TextStyle(color: Colors.white),),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Container(
                        decoration:  const BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(18),bottomLeft: Radius.circular(18),bottomRight: Radius.circular(18)),
                            border: Border.symmetric(vertical: BorderSide.none,horizontal: BorderSide.none)
                        ),
                        alignment: Alignment.center,
                        constraints:const BoxConstraints(
                            minHeight: 50,
                            minWidth: 200,
                        ),
                        child:ShowMessage(content:snap['content'], dateTime: snap['dateTime'].toDate(),type: snap['type'],),
                      ),
                    ),
                  ],
                ),
              );
          },);
        }
      ),
    );
  }
}
