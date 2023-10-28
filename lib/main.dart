import 'package:camera/camera.dart';
import 'package:detect_objects/controller/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detect Objects',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CameraView(),
    );
  }
}

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialize.value
              ? Stack(
                children: [
                  CameraPreview(controller.cameraController),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                          child: Text(
                              controller.label,
                            style: const TextStyle(
                              fontSize: 20
                            ),
                          ),
                      ),
                    ),
                  ),
                ],
              )
              : const Center(
                  child: Text('Loading....'),
                );
        },
      ),
    );
  }
}
