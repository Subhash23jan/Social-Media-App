import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tab_bar/main.dart';
import 'package:tab_bar/screens/login_screen.dart';
import '../utils/usefulumethods.dart';
import '../FIreBase_operations/firebase_auth_methods.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  Uint8List ? profileImage;
  FirebaseAuthMethods firebaseMeth=FirebaseAuthMethods();
  bool _isLoading=false;
  final emailController=TextEditingController(),passwordController=TextEditingController();
  final nameController=TextEditingController();
  final userNameController=TextEditingController();
  final bioController=TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xff150e48),
      body:Container(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
               const SizedBox(height: 80,),
                SizedBox(
                  height: 100,
                  child: SvgPicture.asset('lib/assets/ic_instagram.svg',color: Colors.white,),
                ),
                Stack(
                  children: [
                    profileImage!=null?ClipOval(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:MemoryImage(profileImage!),
                      ),
                    ):const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white60,
                      backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                    ),
                     Positioned(
                      bottom: -1,
                        left: 85,
                        child: IconButton(
                          onPressed:pickImage,
                          icon:const Icon(Icons.add_a_photo),color: Colors.white,))
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                SizedBox(
                  height: 50,
                  width:MediaQuery.of(context).size.width*0.85,
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    keyboardType:TextInputType.name,
                    controller:nameController,
                    decoration: InputDecoration(
                        label:Text("your name",style:GoogleFonts.jetBrainsMono(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
                        hintText:"add your name",
                        hintStyle:GoogleFonts.aBeeZee(color: Colors.white70),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        //icon:Icon(Icons.email,color:Colors.white54,),
                        labelStyle: const TextStyle(
                            color: Colors.indigo
                        ),
                        alignLabelWithHint:true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green,width: 2),
                            borderRadius:BorderRadius.only(
                              topLeft:Radius.circular(20),
                              bottomRight:Radius.circular(20),
                            )
                        )
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width:MediaQuery.of(context).size.width*0.85,
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    keyboardType:TextInputType.name,
                    controller:userNameController,
                    decoration: InputDecoration(
                        label:Text("user id",style:GoogleFonts.jetBrainsMono(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
                        hintText:"add unique user name",
                        hintStyle:GoogleFonts.aBeeZee(color: Colors.white70),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        //icon:Icon(Icons.email,color:Colors.white54,),
                        labelStyle: const TextStyle(
                            color: Colors.indigo
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green,width: 2),
                            borderRadius:BorderRadius.only(
                              topLeft:Radius.circular(20),
                              bottomRight:Radius.circular(20),
                            )
                        )
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width:MediaQuery.of(context).size.width*0.85,
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    keyboardType:TextInputType.name,
                    controller:bioController,
                    decoration: InputDecoration(
                        label:Text("bio",style:GoogleFonts.jetBrainsMono(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
                        hintText:"add your bio",
                        hintStyle:GoogleFonts.aBeeZee(color: Colors.white70),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green,width: 2),
                            borderRadius:BorderRadius.only(
                              topLeft:Radius.circular(20),
                              bottomRight:Radius.circular(20),
                            )
                        )
                    ),
                  ),
                ),
               const SizedBox(height: 15,),
                SizedBox(
                  height: 50,
                  width:MediaQuery.of(context).size.width*0.85,
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    keyboardType:TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                        label:Text("email",style:GoogleFonts.jetBrainsMono(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
                        hintText:"enter your email",
                        hintStyle:GoogleFonts.aBeeZee(color: Colors.white70),
                        prefixIcon: const Icon(Icons.email,color: Colors.white70,),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        floatingLabelStyle:const TextStyle(
                            color: Colors.black
                        ) ,
                        //icon:Icon(Icons.email,color:Colors.white54,),
                        labelStyle: const TextStyle(
                            color: Colors.white70
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green,width: 2),
                            borderRadius:BorderRadius.only(
                              topLeft:Radius.circular(20),
                              bottomRight:Radius.circular(20),
                            )
                        )
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width:MediaQuery.of(context).size.width*0.85,
                  child: TextField(
                    obscureText:true,
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    keyboardType:TextInputType.visiblePassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                        label:Text("password",style:GoogleFonts.jetBrainsMono(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
                        hintText:"enter  password",
                        hintStyle:GoogleFonts.aBeeZee(color: Colors.white70),
                        prefixIcon: const Icon(Icons.fingerprint,color: Colors.white,),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        floatingLabelStyle: const TextStyle(
                            color: Colors.white70
                        ) ,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green,width: 2),
                            borderRadius:BorderRadius.only(
                              topLeft:Radius.circular(20),
                              bottomRight:Radius.circular(20),
                            )
                        )
                    ),
                    expands: false,
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                    style:ButtonStyle(
                      shadowColor: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState>states){
                            return Colors.white;
                          }
                      ),
                      backgroundColor:MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          return Colors.indigo;
                        },
                      ),
                    ),
                    onPressed: (){
                      if(isValid()==true)
                        {
                          createAccount();
                        }
                    },
                    child:_isLoading==false?Text("sign up",style:GoogleFonts.aBeeZee(fontSize: 18),):
                    const CircularProgressIndicator(color: Colors.white,strokeWidth:4,)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("already have an account ?",style:GoogleFonts.aBeeZee(color:Colors.indigo,fontSize: 14,fontWeight: FontWeight.bold),),
                    TextButton(
                      onPressed:(){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => LoginPage(),));
                      },
                      child:Text("click here",style:GoogleFonts.aBeeZee(color:Colors.red,fontSize: 14,fontWeight: FontWeight.bold)),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   pickImage() async{
     final Uint8List ?im=await imagePick(ImageSource.gallery);
       setState(() {
         profileImage=im;
       });
  }

 bool isValid() {
    String name=bioController.text.toString();
    String bio=nameController.text.toString();
    String id=userNameController.text.toString();
    if(name.isEmpty || bio.isEmpty || id.isEmpty || profileImage==null) {
      return false;
    }
    return true;
 }

  createAccount() async{
    String name=bioController.text.toString();
    String bio=nameController.text.toString();
    String id=userNameController.text.toString();
    String email=emailController.text.toString().toLowerCase();
    String password=passwordController.text.toString().toLowerCase();
    String res="failure";
    setState(() {
      _isLoading=true;
    });
    res=await firebaseMeth.signIn(email, password, id,profileImage!, bio, name);
    setState(() {
      _isLoading=false;
    });
    if(!context.mounted) {
      return ;
    }
    if(res=="success")
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(),));
    }else {
      showDialog(context: context, builder: (context) {
        return  AlertDialog(
          title: Text("error occurred",style:GoogleFonts.jetBrainsMono(color:Colors.red,fontSize: 14 ),),
          content:Text(res),
        );
      },);
    }
  }



}
