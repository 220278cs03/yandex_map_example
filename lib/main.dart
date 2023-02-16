import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_map_usage/controller/main_controller.dart';
import 'package:yandex_map_usage/view/pages/my_yandex_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=>MainController())
          ],
          child: const MyYandexMap()
      ),
    );
  }
}