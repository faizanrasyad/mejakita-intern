import 'package:advanced_image_flutter/models/user_model.dart';
import 'package:advanced_image_flutter/networking/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<User>? userList;

  // Get ALL User
  Future<void> getUser() async {
    Dio dio = await DioClient().getClient();
    try {
      Response response = await dio.get('${DioClient().baseUrl}/users');
      List<dynamic> jsonData = response.data;

      setState(() {
        userList = jsonData.map((e) => User.fromJson(e)).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 16, bottom: 8),
                                child: TextFormField(
                                  maxLength: 20,
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Name',
                                      prefixIcon: Icon(Icons.person)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Nama tidak boleh kosong!";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16, bottom: 8),
                                child: TextFormField(
                                  controller: usernameController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Username',
                                      prefixIcon: Icon(Icons.account_circle)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Username tidak boleh kosong!";
                                    }
                                    if (userList!.contains(value)) {
                                      return "Username sudah dipakai!";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16, bottom: 8),
                                child: TextFormField(
                                  controller: passController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.key)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password tidak boleh kosong!";
                                    }
                                    if (value.length < 5) {
                                      return "Password minimal 5 karakter!";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  children: [
                                    Text(
                                      "Sudah punya akun?",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        String name = nameController.text;
                                        String username =
                                            usernameController.text;
                                        String password = passController.text;

                                        DioCommands()
                                            .postUser(name, username, password);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Berhasil Membuat Akun Baru!')));
                                        Navigator.pushNamed(context, '/login');
                                      }
                                    },
                                    child: Text(
                                      'Daftar',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(150, 50)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
