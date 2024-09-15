import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  Uint8List? _capturedImageBytes;
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(cameras![0], ResolutionPreset.high);
      await _cameraController?.initialize();
    }
  }

  Future<void> showDialogCamera() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Camera not initialized');
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 400,
              child: CameraPreview(_cameraController!),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final image = await _cameraController!.takePicture();
                  final bytes = await image.readAsBytes(); // Read image bytes
                  setState(() {
                    _capturedImageBytes = bytes;
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error capturing image: $e');
                }
              },
              child: const Text('Capture Photo'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              shape: BoxShape.circle,
              image: _capturedImageBytes != null
                  ? DecorationImage(
                image: MemoryImage(_capturedImageBytes!), // Use MemoryImage to display image bytes
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: _capturedImageBytes == null
                ? Center(
              child: TextButton(
                onPressed: showDialogCamera,
                child: const Text('Open Camera'),
              ),
            )
                : null,
          ),
          SizedBox(
            width: double.infinity,
          ),
          Container(
            width: 150.w,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            height: 500.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  //controller: _getController.nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    obscureText: false,
                    focusNode: FocusNode(),
                    style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Ism'.tr,
                      filled: true,
                      isDense: true,
                      fillColor: Colors.grey.shade400,
                      hintStyle: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12.r)),
                    )),
                SizedBox(height: 10.h),
                TextField(
                  //controller: _getController.nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    obscureText: false,
                    focusNode: FocusNode(),
                    style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Familiya'.tr,
                      filled: true,
                      isDense: true,
                      fillColor: Colors.grey.shade400,
                      hintStyle: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12.r)),
                    )),
                SizedBox(height: 10.h),
                TextField(
                  //controller: _getController.nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    obscureText: false,
                    focusNode: FocusNode(),
                    style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'yosh'.tr,
                      filled: true,
                      isDense: true,
                      fillColor: Colors.grey.shade400,
                      hintStyle: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12.r)),
                    )),
              ],
            ),
          )
        ],
      ),
      )
  );
}
