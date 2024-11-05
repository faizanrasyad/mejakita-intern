import 'package:advanced_image_flutter/models/user_model.dart';
import 'package:advanced_image_flutter/networking/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? _username;
  String? _password;
  bool _rememberMe = false;
  bool currentRememberMe = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> login(
      String username, String password, BuildContext context) async {
    try {
      Dio dio = await DioClient().getClient();
      Response response = await dio.post("${DioClient().baseUrl}/login",
          queryParameters: {'username': username, 'password': password});

      int responseCode = response.statusCode!;
      if (responseCode == 200) {
        User loggedUser = User.fromJson(response.data);
        print("Logged In User: $loggedUser");
        if (loggedUser.id != null) {
          // Preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', loggedUser.username);
          await prefs.setString('password', loggedUser.password);
          await prefs.setString('name', loggedUser.name);
          await prefs.setInt('id', loggedUser.id);
          await prefs.setBool('rememberMe', currentRememberMe);

          print("Berhasil Log In!");
          print("Prefs Name: ${prefs.getString('name')}");

          // Navigation
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          print("Gagal Memasukkan Ke loggedUser");
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User tidak ditemukan!")));
        print("Status Code Gagal!");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS: ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Masukkan data yang sesuai untuk login.',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: TextFormField(
                                controller: userController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Username',
                                    prefixIcon: Icon(Icons.person)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Username can't be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(),
                              child: TextFormField(
                                controller: passController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.key)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password can't be empty";
                                  }
                                  if (value.length < 5) {
                                    return "Password must have 5 characters minimum";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: currentRememberMe,
                                  onChanged: (bool? value) async {
                                    setState(() {
                                      currentRememberMe = value!;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                                Text(
                                  'Remember Me',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Don't have an account yet?",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  new InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    child: new Text(
                                      "Create an account here",
                                      style: TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    login(userController.text,
                                        passController.text, context);
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    print(
                                        "Prefs Username : ${prefs.getString('username')}");
                                    print(
                                        "Prefs Password : ${prefs.getString('password')}");
                                    print(
                                        "Prefs Name : ${prefs.getString('name')}");
                                    print(
                                        "Prefs Remember Me : ${prefs.getString('rememberMe')}");
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(150, 50)),
                                ),
                              ),
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
        ));
  }
}
