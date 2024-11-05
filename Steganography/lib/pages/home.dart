import 'package:advanced_image_flutter/data/datas.dart';
import 'package:advanced_image_flutter/models/catatan_model.dart';
import 'package:advanced_image_flutter/models/image_model.dart';
import 'package:advanced_image_flutter/models/user_model.dart';
import 'package:advanced_image_flutter/networking/dio.dart';
import 'package:advanced_image_flutter/pages/detailCatatan.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Catatan> catatans = [];

  @override
  void initState() {
    getCatatans();
    _loadPreferences();
    super.initState();
  }

  // DIO Get ALL Catatan
  Future<void> getCatatans() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.get('${DioClient().baseUrl}/catatans');
      List<dynamic> jsonData = response.data;

      setState(() {
        catatans = jsonData.map((e) => Catatan.fromJson(e)).toList();
        Datas().catatansLength = catatans.length;
      });
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS: ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
      return e.response!.data;
    }
  }

  // DIO Get Image bt CatatanId
  Future<List<Gambar>> getImage(int catatanId) async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.get(
          '${DioClient().baseUrl}/imagebycatatanid',
          queryParameters: {'catatanId': catatanId});
      List<dynamic> jsonData = response.data;

      return jsonData.map((e) => Gambar.fromJson(e)).toList();
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS: ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
      return e.response!.data;
    }
  }

  // DIO Get User by Id
  Future<User> getUserbyid(int userId) async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.get(
        '${DioClient().baseUrl}/users/$userId',
      );

      return User.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS: ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
      return e.response!.data;
    }
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('rememberMe') == true) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          if (prefs.getBool('rememberMe') == true) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Image.asset('assets/icon.png'),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                )
              ],
            ),
            Text(
              'List Catatan',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: catatans.length < 1
                    ? const Center(
                        child: Text(
                          "Tidak ada catatan...",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        itemCount: catatans.length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DetailCatatan(
                                          catatan: catatans[index])));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        "${getImage(catatans[index].id).then((value) => value[0].image1)}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          catatans[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "${getUserbyid(catatans[index].author).then((value) => value.name)}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.pages),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "${getImage(catatans[index].id).then((value) => value.length)} Halaman",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })))
          ],
        ),
      )),
    );
  }
}
