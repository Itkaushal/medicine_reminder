import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'add_medicine_screen.dart';
import '../provider/medicine_provider.dart';

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
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: medicines.isEmpty
          ? const Center(
        child: Text(
          "No medicines added yet",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final med = medicines[index];

          final timeText =
          TimeOfDay.fromDateTime(med.time).format(context);

          return Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.medication,
                  color: Colors.teal,
                  size: 28,
                ),
                title: Text(
                  med.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(med.dose),
                trailing: Chip(
                  label: Text(timeText),
                  backgroundColor: Colors.teal.shade50,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
