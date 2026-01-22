import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'add_medicine_screen.dart';
import 'medicine_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final plugin = FlutterLocalNotificationsPlugin();

    await plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  @override
  Widget build(BuildContext context) {
    final medicines = ref.watch(medicineListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Reminder"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddMedicineScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: medicines.isEmpty
          ? const Center(
        child: Text(
          "No medicines added yet",
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (_, index) {
          final med = medicines[index];
          return ListTile(
            leading: const Icon(Icons.medication, color: Colors.teal),
            title: Text(med.name),
            subtitle: Text(
              "${med.dose} • ${TimeOfDay.fromDateTime(med.time).format(context)}",
            ),
          );
        },
      ),
    );
  }
}
