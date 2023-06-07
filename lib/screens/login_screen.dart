import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_bar/FIreBase_operations/firebase_auth_methods.dart';
import 'package:tab_bar/main.dart';
import 'package:tab_bar/screens/sign_up.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool isLoading=false;
  final emailController=TextEditingController(),passwordController=TextEditingController();
  FirebaseAuthMethods firebaseMeth=FirebaseAuthMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black,
      // appBar:AppBar(
      //   title: Text("SignUp page",style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold,),),
      // ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            SizedBox(
              height: 90,
              child: SvgPicture.asset('lib/assets/ic_instagram.svg',color: Colors.white,),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width:MediaQuery.of(context).size.width*0.85,
              child: TextFormField(
                validator:(value) {
                  if(value!.isEmpty) {
                    return "it shouldn't be empty";
                  }
                  if(!(value.contains('@'))) {
                    return "It shpould have @ sign";
                  }
                  return null;
                },
                style: TextStyle(color: Colors.white),
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
                    labelStyle: TextStyle(
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
              height: 30,
            ),
            SizedBox(
              width:MediaQuery.of(context).size.width*0.85,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                obscureText:true,
                keyboardType:TextInputType.visiblePassword,
                controller: passwordController,
                decoration: InputDecoration(
                    label:Text("password",style:GoogleFonts.jetBrainsMono(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
                    hintText:"enter your password",
                    hintStyle:GoogleFonts.aBeeZee(color: Colors.white70),
                    prefixIcon: const Icon(Icons.fingerprint,color: Colors.white,),
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(
                        color: Colors.white70
                    ) ,
                    //icon:Icon(Icons.email,color:Colors.white54,),
                    labelStyle: TextStyle(
                        color: Colors.white
                    ),
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
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 130,
              height:50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15)
              ),
              child: TextButton(
                  onPressed: (){
                    loginwithUser();
                  },
                child:isLoading!=true?Text("Login",style:GoogleFonts.aBeeZee(fontSize: 18,color: Colors.white),):
                const CircularProgressIndicator(color: Colors.white),),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("don't have an account ?",style:GoogleFonts.aBeeZee(color:Colors.indigo,fontSize: 14,fontWeight: FontWeight.bold),),
                TextButton(
                  onPressed: (){
                    Timer(Duration(milliseconds: 100), () {Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => SignUpPage(),));});
                  },
                  child:Text("click here",style:GoogleFonts.aBeeZee(color:Colors.red,fontSize: 14,fontWeight: FontWeight.bold)),),
              ],
            ),

          ],

        ),
      ),
    );
  }

   loginwithUser() async{
      String res='success';
      setState(() {
        isLoading=true;
      });
      try{
        await FirebaseAuth.instance.
        signInWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString());
      }catch(e)
     {
       res=e.toString();
     }
      setState(() {
        isLoading=false;
      });
     if(res=="success")
       {
         Fluttertoast.showToast(msg: "login successfully",fontSize: 14,gravity:ToastGravity.CENTER);
         Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => MyHomePage(
         ),));
       }else
         {
           Fluttertoast.showToast(msg: res,fontSize: 14,gravity:ToastGravity.CENTER);
         }
   }
}
