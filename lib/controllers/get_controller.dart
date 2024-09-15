import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetController extends GetxController {
  var height = 0.0.obs;
  var width = 0.0.obs;
  var fullName = 'Dilshodjon Haydarov'.obs;

  RxBool isPassword = true.obs;
  final supabase = SupabaseClient('https://rbybxilmlottposcejmi.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJieWJ4aWxtbG90dHBvc2Nlam1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NTcxOTgsImV4cCI6MjA0MTAzMzE5OH0.vwZIqQQoc0ofEeY8rtH4VsAQu5Ju7bDICou9bsCXoUM');


  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  var cameras = <CameraDescription>[].obs;

  void initCameras() async {
    cameras.value = await availableCameras();
  }

}