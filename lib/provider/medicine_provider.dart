import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/medicine.dart';
import '../data/medicine_repository.dart';
import '../service/notification_service.dart';


final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  throw UnimplementedError();
});

final medicineListProvider =
StateNotifierProvider<MedicineNotifier, List<Medicine>>(
      (ref) => MedicineNotifier(ref.read(medicineRepositoryProvider)),
);

class MedicineNotifier extends StateNotifier<List<Medicine>> {
  final MedicineRepository repository;

  MedicineNotifier(this.repository) : super([]) {
    loadMedicines();
  }

  void loadMedicines() {
    state = repository.getMedicines();
  }

  Future<void> addMedicine(Medicine medicine) async {
    await repository.addMedicine(medicine);

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await NotificationService.scheduleMedicineNotification(
      id: id,
      medicineName: medicine.name,
      time: medicine.time,
    );

    loadMedicines();
  }

}
