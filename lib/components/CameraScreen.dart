import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

typedef TakePictureCallback = void Function(XFile image);

// A screen that allows users to take a picture using a given camera.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, this.onTakePicture, this.abovePanelChild});

  final TakePictureCallback? onTakePicture;
  final Widget? abovePanelChild;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    _setupCamera();
  }

  Future<void> _setupCamera() async {
    debugPrint("_setupCamera");

    try {
      // initialize cameras.
      _cameras = await availableCameras();
      // initialize camera controllers.
      _cameraController = CameraController(
        // Get a specific camera from the list of available cameras.
        _cameras.first,
        // Define the resolution to use.
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _cameraController.initialize();

      await _initializeControllerFuture;
      // await _initializeControllerFuture;
    } on CameraException catch (_) {
      debugPrint("Some error occured!");
    }

    setState(() {
      _isReady = true;
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final colorScheme = Theme.of(context).colorScheme;

    final cameraButton = GestureDetector(
      onTap: () async {
        try {
          await _initializeControllerFuture;

          final image = await _cameraController.takePicture();

          widget.onTakePicture?.call(image);
        } catch (e) {
          print(e);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.primary, width: 2.0),
            ),
          ),
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(shape: BoxShape.circle, color: colorScheme.primary),
          ),
        ],
      ),
    );

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_cameraController),
                    widget.abovePanelChild != null
                        ? Align(alignment: Alignment.bottomCenter, child: widget.abovePanelChild)
                        : Container(),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          color: colorScheme.onPrimaryContainer,
          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(flex: 1, child: Container()),
                      Align(alignment: Alignment.center, child: cameraButton),
                      Flexible(flex: 1, child: Container()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
