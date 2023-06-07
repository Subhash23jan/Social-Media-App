import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar/FIreBase_operations/firebase_auth_methods.dart';
import 'package:tab_bar/FIreBase_operations/firestore_methods.dart';
import 'package:tab_bar/Models/user_model.dart';
import 'package:tab_bar/providers/user_provider.dart';
import 'package:tab_bar/utils/usefulumethods.dart';

import '../FIreBase_operations/firebase_storage_methods.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isUploading=false;
  final descriptionController=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final UserModel user=Provider.of<UserProvider>(context).getUser;
    return _file==null?Scaffold(
      backgroundColor: Colors.black,
      body:Center(
        child:Stack(
          alignment: Alignment.center,
          children: [
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon:const Icon(Icons.upload,color: Colors.white,size: 20,),
                onPressed: () { pickPost(context);},
              ),
              Text("upload",style:GoogleFonts.jetBrainsMono(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
            ],

          ),

          ]
        )
      )
    ):
    isUploading? Center(
      child: Opacity(
          opacity:1,
          child: Stack(
            alignment:Alignment.center,
            children:  [
              const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
              Center(child: Text('uploading...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white))),
            ],
          )),
    ):Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading:IconButton(
          icon:const Icon(Icons.arrow_back,color: Colors.white,size: 20,),
          onPressed: (){
            setState(() {
              _file=null;
              isUploading=false;
            });
          },
        ),
        actions:<Widget>[
          TextButton(onPressed: (){
            FocusScope.of(context).unfocus();
            setState(() {
              isUploading=true;
            });
             addPost(descriptionController.text,user.uid,user.name,user.profileUrl);
          },
            child: const Text("Post  ",style: TextStyle(color: Colors.blue,fontSize: 16,fontWeight: FontWeight.bold)),)
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*0.35,
                child:TextField(
                  onSubmitted: (value){
                    FocusScope.of(context).unfocus();
                    setState(() {
                      isUploading=true;
                    });
                    addPost(value,user.uid,user.name,user.profileUrl);
                  },
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                      hintText: "write a caption..",
                      hintStyle: TextStyle(color: Colors.white60,)
                  ),
                ),
              ),
              Image(
                image:MemoryImage(_file!),
                width: 100,
                height: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
   pickPost(BuildContext context)async{
    var file;
    return  showDialog(context: context,
      builder: (context) => SimpleDialog(
      title: const Text("Choose from",style: TextStyle(fontSize: 19,color: Colors.white70)),
      backgroundColor: Colors.white10,
      elevation: 100,
      children: [
        SimpleDialogOption(
          padding:const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
          child: const Text("Gallery",style: TextStyle(fontSize: 19,color: Colors.white70)),
          onPressed:() async{
            Navigator.of(context).pop();
            file=await imagePick(ImageSource.gallery);
            setState(() {
              _file=file;
            });
          },
        ),
        SimpleDialogOption(
          padding:const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
          child: const Text("Camera",style: TextStyle(fontSize: 19,color: Colors.white70),),
          onPressed:() async{
            Navigator.of(context).pop();
            file=await imagePick(ImageSource.camera);
            setState(() {
              _file=file;
            });
          },
        ),
        SimpleDialogOption(
          padding:const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
          child: const Text("Cancel",style: TextStyle(fontSize: 19,color: Colors.white70)),
          onPressed:() async{
            Navigator.of(context).pop();
          },
        ),
      ],

    ),);
  }

  addPost(String desc, String userId, String userName,String profilePic) async{
    String? res="error";
     try{
      res=await FirestoreMethods().addPost(userName, profilePic, _file!, userId, desc);
      descriptionController.text="";
     } catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("error")));
    }
    if(res=="success") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("posted")));
    }
    setState(() {
      _file=null;
      isUploading=false;
    });
  }
}

