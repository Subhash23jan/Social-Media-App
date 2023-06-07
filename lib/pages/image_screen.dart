import 'package:flutter/material.dart';

class ImageViewScreen extends StatefulWidget {
  final String postUrl;
  const ImageViewScreen({Key? key, required this.postUrl}) : super(key: key);

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.blue,
        title: const Text("imageView"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              minWidth:150,
              minHeight: 150
            ),
            child: Image.network(widget.postUrl,fit:BoxFit.cover,),
          ),
        ),
      ),
    );
  }
}
