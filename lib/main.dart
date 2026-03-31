import 'package:flutter/material.dart';
import 'core/root/app_root.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const AppRoot());
}
