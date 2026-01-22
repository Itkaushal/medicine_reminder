import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/medicine.dart';
import '../provider/medicine_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() =>
      _AddMedicineScreenState();
}

class _AddMedicineScreenState
    extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Medicine"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // header
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Medicine Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Add medicine name, dose and reminder time",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

           // form
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (v) =>
                        v == null || v.isEmpty
                            ? "Medicine name required"
                            : null,
                        decoration: InputDecoration(
                          labelText: "Medicine Name",
                          prefixIcon:
                          const Icon(Icons.medication),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _doseController,
                        validator: (v) =>
                        v == null || v.isEmpty
                            ? "Dose required"
                            : null,
                        decoration: InputDecoration(
                          labelText: "Dose",
                          prefixIcon:
                          const Icon(Icons.science),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // time picker button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: const Text("Pick Reminder Time"),
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                selectedTime = time;
                              });
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (selectedTime != null)
                        Chip(
                          avatar: const Icon(
                            Icons.alarm,
                            size: 18,
                            color: Colors.teal,
                          ),
                          label: Text(
                            "Reminder at ${selectedTime!.format(context)}",
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text(
                  "Save Medicine",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (!_formKey.currentState!.validate() ||
                      selectedTime == null) return;

                  final now = DateTime.now();
                  final dateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  ref
                      .read(medicineListProvider.notifier)
                      .addMedicine(
                    Medicine(
                      name: _nameController.text,
                      dose: _doseController.text,
                      time: dateTime,
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
