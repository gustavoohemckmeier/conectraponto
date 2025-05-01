import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'package:conectraponto/locator.dart';
import 'package:conectraponto/pages/widgets/FacePainter.dart';
import 'package:conectraponto/pages/widgets/auth-action-button.dart';
import 'package:conectraponto/pages/widgets/camera_header.dart';
import 'package:conectraponto/services/camera.service.dart';
import 'package:conectraponto/services/ml_service.dart';
import 'package:conectraponto/services/face_detector_service.dart';

class AdicionaFoto extends StatefulWidget {
  const AdicionaFoto({Key? key}) : super(key: key);

  @override
  State<AdicionaFoto> createState() => _AdicionaFotoState();
}

class _AdicionaFotoState extends State<AdicionaFoto> {
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;

  bool _detectingFaces = false;
  bool pictureTaken = false;
  bool _initializing = false;
  bool _saving = false;
  bool _bottomSheetVisible = false;

  final FaceDetectorService _faceDetectorService =
      locator<FaceDetectorService>();
  final CameraService _cameraService = locator<CameraService>();
  final MLService _mlService = locator<MLService>();

  @override
  void initState() {
    super.initState();
    _askAccessoryQuestion();
  }

  Future<void> _askAccessoryQuestion() async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Você está usando acessórios?'),
        content: const Text(
            'Está usando óculos escuros, boné ou fones de ouvido?\n\nRemova-os antes de tirar a foto.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'sim'),
            child: const Text('Sim, estou usando'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'nao'),
            child: const Text('Não, estou sem'),
          ),
        ],
      ),
    );

    if (result == 'nao') {
      _startCamera();
    } else {
      Navigator.of(context).pop(); // volta para a tela anterior
    }
  }

  Future<void> _startCamera() async {
    setState(() => _initializing = true);
    await _cameraService.initialize();
    setState(() => _initializing = false);
    _frameFaces();
  }

  Future<bool> _onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('Nenhum rosto detectado!'),
        ),
      );
      return false;
    } else {
      _saving = true;
      await Future.delayed(const Duration(milliseconds: 500));
      final XFile? file = await _cameraService.takePicture();
      imagePath = file?.path;

      setState(() {
        _bottomSheetVisible = true;
        pictureTaken = true;
      });

      return true;
    }
  }

  void _frameFaces() {
    imageSize = _cameraService.getImageSize();
    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController == null) return;
      if (_detectingFaces) return;

      _detectingFaces = true;

      try {
        await _faceDetectorService.detectFacesFromImage(image);
        if (_faceDetectorService.faces.isNotEmpty) {
          setState(() {
            faceDetected = _faceDetectorService.faces[0];
          });
          if (_saving) {
            _mlService.setCurrentPrediction(image, faceDetected);
            setState(() => _saving = false);
          }
        } else {
          setState(() => faceDetected = null);
        }
      } catch (e) {
        print('Erro na detecção de rosto: $e');
      } finally {
        _detectingFaces = false;
      }
    });
  }

  void _reload() {
    setState(() {
      _bottomSheetVisible = false;
      pictureTaken = false;
    });
    _startCamera();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    late Widget body;

    if (_initializing) {
      body = const Center(child: CircularProgressIndicator());
    } else if (pictureTaken && imagePath != null) {
      body = Container(
        width: width,
        height: height,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(mirror),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.file(File(imagePath!)),
          ),
        ),
      );
    } else {
      body = Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                width: width,
                height:
                    width * _cameraService.cameraController!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_cameraService.cameraController!),
                    if (imageSize != null)
                      CustomPaint(
                        painter: FacePainter(
                          face: faceDetected,
                          imageSize: imageSize!,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          body,
          CameraHeader("Tirar Foto",
              onBackPressed: () => Navigator.pop(context)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !_bottomSheetVisible
          ? AuthActionButton(
              onPressed: _onShot,
              isLogin: false,
              reload: _reload,
            )
          : Container(),
    );
  }
}
