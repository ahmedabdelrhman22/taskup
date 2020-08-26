import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/Home.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,

    title: 'Your title',
    home: Home(),
    )
    );}

