import 'dart:convert';
import 'dart:io';

import 'package:advanced_image_flutter/data/datas.dart';
import 'package:advanced_image_flutter/networking/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:http/http.dart' as http;

class CatatanBaru extends StatefulWidget {
  const CatatanBaru({super.key});

  @override
  State<CatatanBaru> createState() => _CatatanBaruState();
}

class _CatatanBaruState extends State<CatatanBaru> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<XFile>? imageList;
  List<String>? imageUrlList;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      imageList = List.empty();
    });
    super.initState();
  }

  XFile? image;
  String? imageUrl;

  Future<bool> checkSuspiciousFile(
      XFile pickedImage, BuildContext context) async {
    var imageAsBytes = await pickedImage.readAsBytes();
    // Convert all bytes into one single hex string
    String hexString = imageAsBytes.map((byte) {
      return byte.toRadixString(16).padLeft(2, '0');
    }).join();

    // List of suspicious text
    List<String> suspiciousCommands = [
      '414c544552', // ALTER
      '616c746572', // alter
      '65786563', // exec
      '45584543', // EXEC
      '65786563757465', // execute
      '45584543555445', // EXECUTE
      '64726f70', // drop
      '44524f50', // DROP
      '73656c656374', // select
      '53454c454354', // SELECT
      '68746d6c', // html
      '48544d4c', // HTML
      '637265617465', // create
      '435245415445' // CREATE
    ];

    for (String command in suspiciousCommands) {
      if (hexString.contains(command)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File is Suspicious!")),
        );
        context.loaderOverlay.hide();
        return false;
      }
    }

    print("Hex Values Length: ${hexString.length ~/ 2}");
    print("Image Path: ${pickedImage.path}");
    return true;
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      List<XFile> pickedImage =
          await ImagePicker().pickMultiImage(imageQuality: 20);
      context.loaderOverlay.show();

      // Null Checking
      if (pickedImage == null) {
        context.loaderOverlay.hide();
        return;
      }

      for (int i = 0; i < pickedImage.length; i++) {
        var imageFile = File(pickedImage[i].path);
        int fileSize = await imageFile.length();
        int maxFileSizeInBytes = 5 * 1024 * 1024;

        // File Size Checking (Must be less than 5 MB [Mega Bytes] )
        if (fileSize >= maxFileSizeInBytes) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("File size is more than 5MB")));
          context.loaderOverlay.hide();
          return;
        }

        // Suspicious File Checking
        var result = await checkSuspiciousFile(pickedImage[i], context);
        if (result == false) {
          context.loaderOverlay.hide();
          return;
        }

        setState(() {
          imageList!.add(pickedImage[i]);
        });
        context.loaderOverlay.hide();
      }
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    if (imageList != null) {
      for (int i = 0; i < imageList!.length; i++) {
        // Upload Image
        final url =
            Uri.parse('https://api.cloudinary.com/v1_1/dcnmqlrf8/upload');

        final request = http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = 'horxoem0'
          ..files.add(
              await http.MultipartFile.fromPath('file', imageList![i].path));

        context.loaderOverlay.show();

        final response = await request.send();

        context.loaderOverlay.hide();

        print("Response Status Code: ${response.statusCode}");

        if (response.statusCode == 200) {
          final responseData = await response.stream.toBytes();
          final responseString = String.fromCharCodes(responseData);
          final jsonMap = jsonDecode(responseString);
          String finalUrl;
          setState(() {
            finalUrl = jsonMap['url'];
            imageUrlList!.add(finalUrl);
            print("Image URL $imageUrl");
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              imageList = List.empty();
              imageUrlList = List.empty();
            });
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Buat Catatan Baru',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: LoaderOverlay(
        child: Expanded(
            child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                      key: formKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Judul Catatan',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 16),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Masukkan judul catatan...',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.flag,
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Judul Catatan tidak boleh kosong!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Text(
                              'Deskripsi Catatan',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 16),
                              child: TextFormField(
                                controller: descController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Masukkan deskripsi catatan...',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.movie_creation,
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Deskripsi Catatan tidak boleh kosong!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Text(
                              'Gambar Catatan',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 16),
                                child: InkWell(
                                    onTap: () {
                                      pickImage(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Unggah Gambar Catatan',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ))),
                            Container(
                              child: imageList != null
                                  ? Container(
                                      child: Column(
                                        children: [
                                          for (int i = 0;
                                              i < imageList!.length;
                                              i++)
                                            Image.file(File(imageList![i].path))
                                        ],
                                      ),
                                    )
                                  : const Center(),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 8),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (imageList != null) {
                                      DioCommands comm = DioCommands();
                                      comm.postCatatan(nameController.text, 1,
                                          descController.text);
                                      for (int i = 0;
                                          i < imageUrlList!.length;
                                          i++) {
                                        comm.postImage(imageUrlList![i],
                                            Datas().catatansLength);
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  ("Gambar Catatan tidak boleh kosong"))));
                                    }
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.cloud_upload),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Add Movie',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ]),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
