import 'package:dansal_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dansal_app/services/auth_service.dart';
import 'package:dansal_app/providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: DansalApp()));
}

class DansalApp extends ConsumerWidget {
  const DansalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Dansal App',
      theme: ThemeData(fontFamily: "inter", primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), // Always show HomeScreen initially
    );
  }
}
