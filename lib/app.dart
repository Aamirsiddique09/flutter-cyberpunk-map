import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/real_map_screen.dart';

class NeoTokyoMapApp extends StatelessWidget {
  const NeoTokyoMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neo-Tokyo 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const RealMapScreen(),
    );
  }
}
