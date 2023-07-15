

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar/FIreBase_operations/firebase_auth_methods.dart';
import 'package:tab_bar/firebase_options.dart';
import 'package:tab_bar/pages/add_post.dart';
import 'package:tab_bar/providers/user_provider.dart';
import 'package:tab_bar/screens/login_screen.dart';
import 'package:tab_bar/utils/finalVariables.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(context) =>UserProvider(),)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor:Colors.black12,
          primaryColor: Colors.white30,

        ),
        home:StreamBuilder(
          stream:FirebaseAuth.instance.authStateChanges(),
          builder:(context, snapshot) {
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                return  const MyHomePage();
              }else if(snapshot.hasError){
                return Container(
                  color: Colors.black,
                  child: Text('${snapshot.error}',style: const TextStyle(color: Colors.white),),
                );
              }
            }else if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
            child: CircularProgressIndicator(strokeWidth: 4,),
            );
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuthMethods firebaseMeth=FirebaseAuthMethods();
  late PageController _pagecontroller;
  int page=0;
  @override
  void initState() {
    super.initState();
    _pagecontroller=PageController();
    Future.delayed(Duration.zero,(){
      getUserName();
    });
  }
  @override
  void dispose() {
    super.dispose();
   PageController().dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).backgroundColor,
      bottomNavigationBar:CupertinoTabBar(
        backgroundColor: Colors.black,
          items: [
            BottomNavigationBarItem(icon:Icon(Icons.home_outlined,color:page==0?Colors.blue:Colors.white30,),label: '',
                backgroundColor: Colors.black),
            BottomNavigationBarItem(icon:Icon(Icons.search,color:page==1?Colors.blue:Colors.white30),label: ''),
            BottomNavigationBarItem(icon:Icon(Icons.add_a_photo_outlined,color:page==2?Colors.blue:Colors.white30),label: ''),
            BottomNavigationBarItem(icon:Icon(Icons.favorite,color:page==3?Colors.blue:Colors.white30),label: ''),
            BottomNavigationBarItem(icon:Icon(Icons.person_2_outlined,color:page==4?Colors.blue:Colors.white30),label: ''),
          ],
          onTap:onNavigationTap,),
      body:PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller:_pagecontroller,
        children:screens,
      ),
    );
  }

  void onNavigationTap(int value) {
    setState(() {
      page=value;
    });
    _pagecontroller.jumpToPage(value);
  }
  getUserName() async{
    UserProvider userProvider=Provider.of<UserProvider>(context,listen: false);
    userProvider.refreshUser();
  }
}
