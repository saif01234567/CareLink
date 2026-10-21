import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/medication/screens/today_screen.dart';

class CareLinkApp extends StatelessWidget {
  const CareLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const TodayScreen(),
    );
  }
}
