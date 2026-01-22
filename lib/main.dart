import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'AppTheme.dart';
import 'home_screen.dart';
import 'medicine.dart';
import 'medicine_provider.dart';
import 'medicine_repository.dart';
import 'notification_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  await Hive.initFlutter();
  Hive.registerAdapter(MedicineAdapter());

  final medicineBox = await Hive.openBox<Medicine>('medicinesBox');

  runApp(
    ProviderScope(
      overrides: [
        medicineRepositoryProvider.overrideWithValue(
          MedicineRepository(medicineBox),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: HomeScreen(),
    );
  }
}
