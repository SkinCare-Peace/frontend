import 'dart:io';
import 'package:camera/camera.dart';
import 'package:frontend/main.dart';
import 'package:frontend/util/screen_mode.dart'; //화면 모드
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';


class CameraView extends StatefulWidget {
  final String title;
  final CustomPaint? customPaint; //페인트
  final String? text; //감지된거 텍스트 표현
  final Function(InputImage inputImage) onImage; //이미지 처리용 콜백 함수 
  final CameraLensDirection initialDirection; //초기 카메라 방향(전면,후면)

  const CameraView({
    super.key,
    required this.title,
    required this.onImage,
    required this.initialDirection,
    this.customPaint,
    this.text,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ScreenMode _mode = ScreenMode.live; //현재 모드
  CameraController? _controller; //카메라 컨트롤러
  File? _image; //선택 이미지 파일
  String? _path; //선택 이미 정료
  ImagePicker? _imagePicker; //이미지 선택기
  int _cameraIndex = 0; //현재 활성화된 카메라 index
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0; //줌 레벨 관리 (필요 없을듯)
  final bool _allowPicker = true; //갤러리에서 선택 가능 여부
  bool _changingCameraLens = false; //카메라 렌즈변경중

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker(); //이미지 선택 초기화

    // 초기 카메라 방향에 맞는 카메라 인덱스 설정
    if (cameras.any((element) =>
        element.lensDirection == widget.initialDirection &&
        element.sensorOrientation == 90)) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
            (element) => element.lensDirection == widget.initialDirection),
      );
    }
    _startLive(); //라이브 모드 시작
  }


// 실시간 카메라 시작 메소드
  Future _startLive() async {
    final camera = cameras[_cameraIndex]; //현재 선택된 카메라 
    _controller = CameraController(
      camera,
      ResolutionPreset.high,// 해상도 높게 설정
      enableAudio: false, // 오디오 안씀
    );
    // 카메라 초기화 후, 이미지 스트림 시작
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      //줌레벨 설정
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
        minZoomLevel = value;
      });
      // 실시간 이미지를 시작해서 프레임 처리
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

// 실시간 카메라 이미지 처리 메소드
  Future _processCameraImage(final CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final camera = cameras[_cameraIndex];
    final imageRotation = InputImageRotationValue.fromRawValue(
            camera.sensorOrientation) ??
        InputImageRotation.rotation0deg; //이미지 회전 각도
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21; //이미지 포멧

    // 각 카메라 이미지의 plane 데이터저장
    final planeData = image.planes.map((final Plane plane) {
      return InputImagePlaneMetadata(
        bytesPerRow: plane.bytesPerRow,
        height: plane.height,
        width: plane.width,
      );
    }).toList();
    
    //InputImageData 객체 생성 (이미지's 메타데이터)
    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
    //InputImageData 객체 생성 (실제 이미지 데이터)
    final inputImage = InputImage.fromBytes(
      bytes: bytes,
     inputImageData: inputImageData, 
    );
    widget.onImage(inputImage); //이미지 처리 콜백함수 호출
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            if (_allowPicker)
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: _switchScreenMode,
                  child: Icon(
                    _mode == ScreenMode.live
                        ? Icons.photo_library_rounded
                        : (Platform.isIOS
                            ? Icons.camera_alt_outlined
                            : Icons.camera),
                  ),
                ),
              ),
          ],
        ),
        body: _body(),
        floatingActionButton: _floatingActionButton(), //카메라 전환 버튼
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );

//카메라 전환 버튼
  Widget? _floatingActionButton() {
    if (_mode == ScreenMode.gallery) return null; //갤러리 경우, 버튼 숨김
    if (cameras.length == 1) return null;// 카메라가 1개인 경우 버튼 숨김
    return SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        onPressed: _switcherCamera,// 카메라 전환 메소드 호출
        child: Icon(
          Platform.isIOS
              ? Icons.flip_camera_ios_outlined
              : Icons.flip_camera_android_outlined,
        ),
      ),
    );
  }

// 카메라 전환 메소드 (전면 <-> 후면)
  Future _switcherCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % cameras.length; // 카메라 인덱스 변경
    await _stopLive();// 현재 카메라 종료
    await _startLive(); // 새로운 카메라 시작
    setState(() => _changingCameraLens = false);
  }

//갤러리 모드 UI 
  Widget _galleryBody() => ListView(
        shrinkWrap: true,
        children: [
          _image != null
              ? SizedBox(
                  height: 400,
                  width: 400,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(_image!),// 갤러리에서 선택된 이미지 표시
                      if (widget.customPaint != null) widget.customPaint!,// 커스텀 페인트가 있으면 표시
                    ],
                  ),
                )
              : const Icon(
                  Icons.image,
                  size: 200,
                ), // 이미지가 없는 경우 기본 이미지 아이콘 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),//갤에서 이미지 선택
              child: const Text('From Gallery'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera), //카메라로 이미지 촬영
              child: const Text('Take a picture'),
            ),
          ),
          if (_image != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${_path == null ? '' : 'image path: $_path'}\n\n${widget.text ?? ''}', //이미지 경로, 텍스트 표시
              ),
            ),
        ],
      );

// 이미지 선택 메소드 (갤러리 혹은 카메라에서) - 이거도 없애도되나
  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);//이미지 선택기
    if (pickedFile != null) {
      _processPickedFile(pickedFile); //선택된 이미지 처리 
    }
    setState(() {});
  }

//선택된 이미지 파일 처리 
  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path); //이미지 파일로 설정
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);// 파일 경로에서 InputImage 생성
    widget.onImage(inputImage);// 이미지 처리 콜백 함수 호출
  }

// 현재 화면에 표시될 내용 설정 (실시간 카메라 vs 갤러리)
  Widget _body() {
    Widget body;
    if (_mode == ScreenMode.live) {
      body = _livebody();// 실시간 카메라 화면
    } else {
      body = _galleryBody();// 갤러리 화면
    }
    return body;
  }

// 실시간 카메라 화면 UI
  Widget _livebody() {
    if (_controller?.value.isInitialized == false) {
      return Container(); // 카메라가 초기화되지 않았을 경우 빈 화면
    }
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller!.value.aspectRatio;// 화면 비율 맞추기
    if (scale < 1) scale = 1 / scale;
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: scale,
            child: Center(
              child: _changingCameraLens
                  ? const Center(
                      child: Text('changing camera Lens'),// 카메라 렌즈 전환 중 표시
                    )
                  : CameraPreview(_controller!), // 카메라 미리보기 화면
            ),
          ),
          if (widget.customPaint != null) widget.customPaint!,// 얼굴 인식 결과 등 추가 그리기
          Positioned(
            bottom: 100,
            left: 50,
            right: 50,
            child: Slider(
              value: zoomLevel,
              min: minZoomLevel,
              max: maxZoomLevel,
              onChanged: (final newSliderValue) {
                setState(() {
                  zoomLevel = newSliderValue;// 줌 레벨 조절
                  _controller!.setZoomLevel(zoomLevel); // 카메라 줌 레벨 설정
                });
              },
              divisions: (maxZoomLevel - 1).toInt() < 1
                  ? null
                  : (maxZoomLevel - 1).toInt(),
            ),
          ),
        ],
      ),
    );
  }

// 화면 모드 전환 (갤러리 <-> 실시간)
  void _switchScreenMode() {
    _image = null;
    if (_mode == ScreenMode.live) {
      _mode = ScreenMode.gallery;// 갤러리 모드로 전환
      _stopLive();
    } else {
      _mode = ScreenMode.live;// 실시간 모드로 전환
      _startLive();
    }
    setState(() {});
  }

// 실시간 카메라 스트림 종료 메소드
  Future _stopLive() async {
    await _controller?.stopImageStream(); // 이미지 스트림 중지
    await _controller?.dispose(); //카메라 컨트롤러 해제
    _controller = null;
  }
}