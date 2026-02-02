import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/posts_provider.dart';
import 'screens/posts_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostsProvider(),
      child: MaterialApp(
        title: 'Posts',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lexend',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF262626),
            brightness: Brightness.light,
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF262626),
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
          ),
          useMaterial3: true,
          textTheme: const TextTheme().apply(
            fontFamily: 'Lexend',
            bodyColor: Color(0xFF262626),
            displayColor: Color(0xFF262626),
          ),
        ),
        home: const PostsScreen(),
      ),
    );
  }
}
