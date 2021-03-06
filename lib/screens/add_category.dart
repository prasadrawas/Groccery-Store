import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/screens/loading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  File _image;
  String imageLink = '';
  final picker = ImagePicker();
  bool isProcessing = false;
  StorageUploadTask uploadTask;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color(0xFF202A36),
      appBar: AppBar(
        backgroundColor: Color(0xFF202A36),
        title: Text(
          'Add Category',
          style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
        ),
      ),
      body: isProcessing
          ? LoadingScreen()
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Category ',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontSize: height * 0.030,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Details',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      letterSpacing: 2,
                                      color: Color(0xFFF85547),
                                      fontSize: height * 0.030,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.030,
                            ),
                            Center(
                              child: Text(
                                'Tell us a bit more about your category',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontSize: height * 0.020,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.040,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: height * 0.055,
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                        controller: _categoryController,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          fontSize: 17,
                                        ),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              color: Colors.black54),
                                          hintText: 'Category name',
                                          border: InputBorder.none,
                                        )),
                                  ),
                                  SizedBox(
                                    height: height * 0.030,
                                  ),
                                  Container(
                                    height: height * 0.055,
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                        controller: _priceController,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          fontSize: 17,
                                        ),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              color: Colors.black54),
                                          hintText: 'Starting price',
                                          border: InputBorder.none,
                                        )),
                                  ),
                                  SizedBox(
                                    height: height * 0.030,
                                  ),
                                  Ink(
                                    height: height * 0.055,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        showImagePickOptions(context);
                                      },
                                      child: Center(
                                        child: Text(
                                          'Add Imge',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: width * 0.70,
                                    child: uploadTask != null
                                        ? StreamBuilder<StorageTaskEvent>(
                                            stream: uploadTask.events,
                                            builder: (context, snapshot) {
                                              var event =
                                                  snapshot?.data?.snapshot;
                                              double progressPercentage =
                                                  event != null
                                                      ? event.bytesTransferred /
                                                          event.totalByteCount
                                                      : 0;

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  LinearProgressIndicator(
                                                    value: progressPercentage,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    (progressPercentage * 100)
                                                            .toInt()
                                                            .toString() +
                                                        " %",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: 'OpenSans',
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        : null,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Ink(
                                    height: height * 0.050,
                                    width: width * 0.70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(
                                        0xFFF85547,
                                      ),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        if (isDataValid())
                                          storeData();
                                        else
                                          _showSnackbar(context,
                                              'Please fill all the fields');
                                      },
                                      child: Center(
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future uploadImage() async {
    try {
      var res = await InternetAddress.lookup('google.com');
      if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
        try {
          final StorageReference storageReference =
              FirebaseStorage().ref().child('menuitems/${DateTime.now()}.png');

          if (mounted) {
            setState(() {
              uploadTask = storageReference.putFile(_image);
            });
          }
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          imageLink = await taskSnapshot.ref.getDownloadURL();
          _showSnackbar(context, 'Image upload successfully');
        } catch (e) {
          _showSnackbar(context, 'Image uploaded failed !');
        }
      }
    } catch (e) {
      _showSnackbar(context, 'No internet connection');
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await cropImage();
      //await compressImage();
      await uploadImage();
    } else {
      print('No image selected.');
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await cropImage();
      await uploadImage();
    } else {
      print('No image selected.');
    }
  }

  showImagePickOptions(BuildContext context) {
    showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Container(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.image,
                        color: Color(0xFFF85547),
                        size: 30,
                      ),
                      Text(
                        "Where do you want to pick the image.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Ink(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xFFF85547)),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.pop(context);
                                getImageFromGallery();
                              },
                              child: Center(
                                child: Text(
                                  'Gallery',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'OpenSans',
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Ink(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFF85547),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xFFF85547)),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.pop(context);
                                getImageFromCamera();
                              },
                              child: Center(
                                child: Text(
                                  'Camera',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        context: context,
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {});
  }

  Future cropImage() async {
    _image = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
  }

  bool isDataValid() {
    if (_categoryController.text.length >= 2 && imageLink != '') return true;
    return false;
  }

  storeData() async {
    try {
      var res = await InternetAddress.lookup('google.com');
      if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
        try {
          if (mounted) {
            setState(() {
              isProcessing = true;
            });
          }
          CollectionReference list =
              FirebaseFirestore.instance.collection('menulist');
          await list.add({
            'name': _categoryController.text.substring(0, 1).toUpperCase() +
                _categoryController.text.substring(1).toLowerCase(),
            'price': int.parse(_priceController.text),
            'image': imageLink,
          });

          if (mounted) {
            setState(() {
              _categoryController.clear();
              _priceController.clear();
              imageLink = '';
              uploadTask = null;
              isProcessing = false;
            });
          }
          _showSnackbar(context, 'Category added successfully');
        } catch (e) {
          if (mounted) {
            setState(() {
              isProcessing = false;
            });
          }
          _showSnackbar(context, 'Unable to add category.');
        }
      }
    } catch (e) {
      _showSnackbar(context, 'No internet connection');
    }
  }

  _showSnackbar(BuildContext context, String error) {
    FocusScope.of(context).unfocus();
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(error),
      duration: Duration(milliseconds: 800),
    ));
  }
}
