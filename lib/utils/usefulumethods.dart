

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

imagePick(ImageSource source) async{
  XFile ? file=await ImagePicker().pickImage(source: source);
  if(file!=null)
    {
      return await file.readAsBytes();
    }else {
    print("Error occurred");
  }
}