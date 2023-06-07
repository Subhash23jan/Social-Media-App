
import 'package:flutter/material.dart';

class ShowMessage extends StatelessWidget {
  final String type;
  final String content;
  final DateTime dateTime;
  const ShowMessage({Key? key, required this.content, required this.dateTime, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  type=='send'?Text(content,style: const TextStyle(fontSize: 17),textAlign:TextAlign.center,softWrap: true,)
        :Text(content,style: const TextStyle(fontSize: 17,color: Colors.white),textAlign:TextAlign.center,softWrap: true,);
  }
}
