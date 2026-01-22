import 'package:hive/hive.dart';

import '../model/medicine.dart';

class MedicineRepository {
  final Box<Medicine> box;

  MedicineRepository(this.box);

  List<Medicine> getMedicines() {
    final list = box.values.toList();
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }

  Future<void> addMedicine(Medicine medicine) async {
    await box.add(medicine);
  }
}
