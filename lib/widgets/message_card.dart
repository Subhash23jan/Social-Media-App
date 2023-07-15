
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowMessage extends StatelessWidget {
  final String type;
  final String content;
  final DateTime dateTime;
  const ShowMessage({Key? key, required this.content, required this.dateTime, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  type=='send'?Center(child: Text(content,style:  GoogleFonts.aBeeZee(fontSize: 17,color: Colors.white),textAlign:TextAlign.center,softWrap: true,))
        :Text(content,style:GoogleFonts.aBeeZee(fontSize: 17,color: Colors.white),textAlign:TextAlign.center,softWrap: true,);
  }
}
