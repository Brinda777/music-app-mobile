import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/app.dart';
import 'package:sangeet/core/networking/local/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init(); // Initializing Hive
  runApp(const ProviderScope(child: App()));
}
