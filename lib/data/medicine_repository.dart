import 'package:hive/hive.dart';

import '../model/medicine.dart';

class MedicineRepository {
  final Box<Medicine> box;

  MedicineRepository(this.box);

  // get all medicine list.
  List<Medicine> getMedicines() {
    final list = box.values.toList();
    list.sort((a, b) {
      final aMinutes = a.time.hour * 60 + a.time.minute;
      final bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });
    return list;
  }

  // add medicine fun.
  Future<void> addMedicine(Medicine medicine) async {
    await box.add(medicine);
  }


}
