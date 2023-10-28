import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    initCamera();
    initTflite();
    super.onInit();
    initCamera();
    initTflite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  //late CameraImage cameraImage;

  var isCameraInitialize = false.obs;
  var cameraCount = 0;
  var label = '';

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );

      await cameraController.initialize().then((value) {
          cameraController.startImageStream((image) {
            // cameraCount++;
            // if(cameraCount % 10 == 0){
            //   cameraCount = 0;
            //   objectDetector(image);
            // }
            objectDetector(image);
            update();
          });
      }).catchError((err){
        print(err.toString());
      });
      isCameraInitialize(true);
      update();
    } else {
      print('denny');
    }
  }
  
  initTflite() async{
    await Tflite.loadModel(
        model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      rotation: 90,
      threshold: 0.4,
    );

    if(detector!=null){
      if(detector.first['confidence']*100 > 45){
        label = detector.first['label'].toString();
        // h = detector.first['rect']['h'];
        // w = detector.first['rect']['w'];
        // x = detector.first['rect']['x'];
        // y = detector.first['rect']['y'];
        print("**********************$label");

        log('result $detector');
      }
      update();
    }
  }
}
