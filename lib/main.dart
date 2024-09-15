import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'add_user_page.dart';
import 'controllers/get_controller.dart';
import 'home_page.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rbybxilmlottposcejmi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJieWJ4aWxtbG90dHBvc2Nlam1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NTcxOTgsImV4cCI6MjA0MTAzMzE5OH0.vwZIqQQoc0ofEeY8rtH4VsAQu5Ju7bDICou9bsCXoUM',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          //home: const MyHomePage(title: 'Kirish'),
          //home: HomePage(),
          getPages: [
            GetPage(name: '/', page: () => HomePage()),
            GetPage(name: '/AddUserPage', page: () => AddUserPage()), // Make sure this is defined
          ],
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GetController _getController = Get.put(GetController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //midnigt
      backgroundColor: Colors.black87,
      body: Obx(
        () => SingleChildScrollView(
            child: Center(
              child: Container(
                  width: 150.w,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  height: 500.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 55.sp,
                              height: 55.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Center(
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.black87,
                                size: 50.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text('Kirish uchun barcha ma\'lumotlarni kiriting'.tr, textAlign: TextAlign.center, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Colors.black87)),
                      const SizedBox(height: 20),
                      TextField(
                          controller: _getController.nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          focusNode: FocusNode(),
                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            hintText: 'Kiriting'.tr,
                            filled: true,
                            isDense: true,
                            fillColor: Colors.grey.shade400,
                            hintStyle: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12.r)),
                          )),
                      const SizedBox(height: 20),
                      TextField(
                          controller: _getController.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          obscureText: _getController.isPassword.value,
                          focusNode: FocusNode(),
                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface),
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              hintText: 'Kiriting'.tr,
                              filled: true,
                              isDense: true,
                              fillColor: Colors.grey.shade400,
                              hintStyle: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12.r)),
                              suffixIcon: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                      onTap: () {_getController.isPassword.value = !_getController.isPassword.value;},
                                      child: Icon(_getController.isPassword.isTrue ? Icons.visibility_off : Icons.visibility, size: Theme.of(context).iconTheme.fill)
                                  )
                              )
                          )),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 150.sp,
                        child: ElevatedButton(
                            onPressed: () async {
                              //if cupabse company table in name and password in database open home page
                              final name = _getController.nameController.text;
                              final password = _getController.passwordController.text;
                              print(name);
                              print(password);
                              try {
                                // Fetch user data from Supabase
                                final response = await Supabase.instance.client
                                    .from('company')
                                    .select()
                                    .eq('name', name)
                                    .eq('password', password)
                                    .single(); // Assuming the name-password combination is unique
                                //soucsess: {id: 1, created_at: 2024-09-04T17:25:09+00:00, name: Teda, description: test uchun, password: 1234, company: 1000}
                                if (response.isNotEmpty) {
                                  Get.offAll(() => HomePage());
                                }
                                print(response);
                              } catch (error) {
                                Get.snackbar('Error', 'Failed to authenticate. Please try again.', backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 1),borderRadius: 12.r,padding: const EdgeInsets.all(12),margin: const EdgeInsets.all(12),);
                                print('Error: $error');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                              elevation: 0,
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.black,
                            ),
                            child: Text('Kirish'.tr, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Colors.white))
                        )
                      )
                    ],
                  )
              ),
            )
        )
      )
    );
  }
}
