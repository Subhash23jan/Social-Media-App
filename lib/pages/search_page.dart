import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching=false;
  final TextEditingController searchInputController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:  TextField(
          onTap: () {
            setState(() {
              isSearching=false;
            });
          },
          onSubmitted:(value) {
            setState(() {
              isSearching=true;
            });
          },
          controller: searchInputController,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18
          ),
          decoration:  InputDecoration(
            suffixIcon:IconButton(
              onPressed: () {  },
              icon: const Icon(Icons.search,color: Colors.white,size: 27,),
            ),
            hintText: "search user",
            hintStyle:const TextStyle(
                color: Colors.white70,
                fontSize: 18
            ),
            border:InputBorder.none,
          ),
        ),
      ),
      body:isSearching?FutureBuilder(
        future:FirebaseFirestore.instance.collection("users").where('name',isGreaterThanOrEqualTo:searchInputController.text.toLowerCase()).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Stack(
              alignment:Alignment.center,
              children:  [
                const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
                Center(child: Text('searching...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white))),
              ],
            ) ;
          }
          return ListView.builder(
            itemCount:(snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
            return  ListTile(
              leading:CircleAvatar(
                radius: 20,
                backgroundImage:NetworkImage((snapshot.data! as dynamic).docs[index]['profile_url']),
              ),
              title:InkWell(
                onTap:(){},
                  child: Text((snapshot.data! as dynamic).docs[index]['name'],style: const TextStyle(color: Colors.white),)),
            );
          },);
        },
      ):Stack(
        alignment:Alignment.center,
        children:  [
          const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
          Center(child: Text('fetching...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white))),
        ],
      )
    );
  }
}
