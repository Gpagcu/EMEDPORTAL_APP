import 'package:flutter/material.dart';

class MockRepository {
  MockRepository._internal() {
    // initialize mock data
    doctors.value = [
      {
        'id': 'd1',
        'name': 'Dr. Alice Cortez',
        'specialty': 'Internal Medicine',
        'availStart': TimeOfDay(hour: 9, minute: 0),
        'availEnd': TimeOfDay(hour: 17, minute: 0),
        'notes': 'Experienced in adult medicine.'
      },
      {
        'id': 'd2',
        'name': 'Dr. Ben Reyes',
        'specialty': 'Pediatrics',
        'availStart': TimeOfDay(hour: 8, minute: 30),
        'availEnd': TimeOfDay(hour: 16, minute: 30),
        'notes': 'Loves working with children.'
      },
    ];

    appointments.value = [
      {
        'id': 'a1',
        'doctorId': 'd1',
        'patient': 'Juan Karlos',
        'queue': 1,
        'priority': 'Urgent',
        'datetime': DateTime(2025, 8, 25, 11, 0),
        'symptoms': 'Stomach ache',
        'resolved': false,
      },
      {
        'id': 'a2',
        'doctorId': 'd1',
        'patient': 'Maria Clara',
        'queue': 2,
        'priority': 'Normal',
        'datetime': DateTime(2025, 8, 25, 11, 30),
        'symptoms': 'Headache',
        'resolved': false,
      },
      {
        'id': 'a3',
        'doctorId': 'd2',
        'patient': 'Lito Ramos',
        'queue': 3,
        'priority': 'Normal',
        'datetime': DateTime.now().add(const Duration(days: 1, hours: 2)),
        'symptoms': 'Back pain',
        'resolved': false,
      },
    ];

    inventory.value = [
      {'id': 'i1', 'name': 'Clindamycin', 'dosage': '150mg', 'quantity': 254, 'unit': 'capsules', 'expires': DateTime(2026, 9, 1), 'category': 'Antibiotics', 'form': 'Capsule', 'stockType': 'Long-Term'},
      {'id': 'i2', 'name': 'Clindamycin', 'dosage': '300mg', 'quantity': 32, 'unit': 'capsules', 'expires': DateTime(2024, 9, 1), 'category': 'Antibiotics', 'form': 'Capsule', 'stockType': 'Low Stock'},
      {'id': 'i3', 'name': 'Paracetamol', 'dosage': '500mg', 'quantity': 48, 'unit': 'bottles', 'expires': DateTime(2026, 9, 1), 'category': 'Analgesics', 'form': 'Bottle', 'stockType': 'Low Stock'},
      {'id': 'i4', 'name': 'Cetirizine Syrup', 'dosage': '5mg/5ml', 'quantity': 178, 'unit': 'bottles', 'expires': DateTime(2026, 9, 1), 'category': 'Antihistamines', 'form': 'Syrup', 'stockType': 'Long-Term'},
      {'id': 'i5', 'name': 'Omeprazole Injection', 'dosage': '40mg', 'quantity': 232, 'unit': 'vials', 'expires': DateTime(2025, 9, 1), 'category': 'IV Fluids', 'form': 'IV', 'stockType': 'Long-Term'},
      {'id': 'i6', 'name': 'Tetracycline', 'dosage': '250mg', 'quantity': 60, 'unit': 'capsules', 'expires': DateTime(2024, 9, 1), 'category': 'Antibiotics', 'form': 'Capsule', 'stockType': 'Low Stock'},
      {'id': 'i7', 'name': 'Tetracycline', 'dosage': '500mg', 'quantity': 163, 'unit': 'capsules', 'expires': DateTime(2025, 9, 1), 'category': 'Antibiotics', 'form': 'Capsule', 'stockType': 'Long-Term'},
      {'id': 'i8', 'name': 'Meclizine', 'dosage': '12.5mg', 'quantity': 43, 'unit': 'tablets', 'expires': DateTime(2026, 9, 1), 'category': 'Analgesics', 'form': 'Tablet', 'stockType': 'Low Stock'},
      {'id': 'i9', 'name': 'Montelukast', 'dosage': '5mg', 'quantity': 254, 'unit': 'tablets', 'expires': DateTime(2024, 9, 1), 'category': 'Respiratory', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i10', 'name': 'Montelukast', 'dosage': '10mg', 'quantity': 135, 'unit': 'tablets', 'expires': DateTime(2026, 9, 1), 'category': 'Respiratory', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i11', 'name': 'Rosuvastatin', 'dosage': '5mg', 'quantity': 227, 'unit': 'tablets', 'expires': DateTime(2026, 9, 1), 'category': 'Cardiac', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i12', 'name': 'Rosuvastatin', 'dosage': '10mg', 'quantity': 195, 'unit': 'tablets', 'expires': DateTime(2024, 9, 1), 'category': 'Cardiac', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i13', 'name': 'Rosuvastatin', 'dosage': '20mg', 'quantity': 196, 'unit': 'tablets', 'expires': DateTime(2025, 9, 1), 'category': 'Cardiac', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i14', 'name': 'Amlodipine', 'dosage': '5mg', 'quantity': 249, 'unit': 'tablets', 'expires': DateTime(2026, 9, 1), 'category': 'Antihypertensives', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i15', 'name': 'Vitamin C', 'dosage': '500mg', 'quantity': 182, 'unit': 'tablets', 'expires': DateTime(2026, 9, 1), 'category': 'Supplements', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i16', 'name': 'Ibuprofen', 'dosage': '400mg', 'quantity': 45, 'unit': 'tablets', 'expires': DateTime(2025, 8, 1), 'category': 'Analgesics', 'form': 'Tablet', 'stockType': 'Low Stock'},
      {'id': 'i17', 'name': 'Azithromycin', 'dosage': '500mg', 'quantity': 210, 'unit': 'tablets', 'expires': DateTime(2026, 7, 1), 'category': 'Antibiotics', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i18', 'name': 'Metformin', 'dosage': '500mg', 'quantity': 300, 'unit': 'tablets', 'expires': DateTime(2025, 12, 1), 'category': 'Antidiabetics', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i19', 'name': 'Losartan', 'dosage': '50mg', 'quantity': 120, 'unit': 'tablets', 'expires': DateTime(2027, 1, 1), 'category': 'Antihypertensives', 'form': 'Tablet', 'stockType': 'Long-Term'},
      {'id': 'i20', 'name': 'Salbutamol Inhaler', 'dosage': '100mcg', 'quantity': 25, 'unit': 'inhalers', 'expires': DateTime(2025, 11, 1), 'category': 'Inhalers/Injectables', 'form': 'Inhaler', 'stockType': 'Low Stock'},
    ];
    // seed sample needed medications and a reminder
    seedNeededMedications();
    reminders.value = [
      {'id': 'r1', 'name': 'Paracetamol', 'time': '08:00 AM', 'date': DateTime.now().add(const Duration(hours: 1)), 'status': 'upcoming'},
    ];
  }

  static final MockRepository instance = MockRepository._internal();

  final ValueNotifier<List<Map<String, dynamic>>> doctors = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> appointments = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> inventory = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> reminders = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> neededMedications = ValueNotifier([]);

  List<Map<String, dynamic>> getDoctors() => List.of(doctors.value);
  List<Map<String, dynamic>> getAppointments() => List.of(appointments.value);

  List<Map<String, dynamic>> getAppointmentsForDoctor(String doctorId) {
    return appointments.value.where((a) => a['doctorId'] == doctorId).toList();
  }

  List<Map<String, dynamic>> getInventory() => List.of(inventory.value);

  List<Map<String, dynamic>> getReminders() => List.of(reminders.value);
  List<Map<String, dynamic>> getNeededMedications() => List.of(neededMedications.value);

  void addInventoryItem(Map<String, dynamic> item) {
    final list = List.of(inventory.value);
    list.add(item);
    inventory.value = list;
  }

  void updateInventoryItem(String id, Map<String, dynamic> updated) {
    final list = List.of(inventory.value);
    final idx = list.indexWhere((i) => i['id'] == id);
    if (idx >= 0) {
      list[idx] = updated;
      inventory.value = list;
    }
  }

  void deleteInventoryItem(String id) {
    final list = List.of(inventory.value)..removeWhere((i) => i['id'] == id);
    inventory.value = list;
  }

  void addReminder(Map<String, dynamic> reminder) {
    final list = List.of(reminders.value);
    list.add(reminder);
    reminders.value = list;
  }

  void removeReminder(String id) {
    final list = List.of(reminders.value)..removeWhere((r) => r['id'] == id);
    reminders.value = list;
  }

  void seedNeededMedications() {
    neededMedications.value = [
      {'id': 'm1', 'name': 'Paracetamol', 'dosage': '500mg', 'frequency': 'TID'},
      {'id': 'm2', 'name': 'Ibuprofen', 'dosage': '400mg', 'frequency': 'BID'},
    ];
  }

  void addDoctor(Map<String, dynamic> doc) {
    final list = List.of(doctors.value);
    list.add(doc);
    doctors.value = list;
  }

  void updateDoctor(String id, Map<String, dynamic> updated) {
    final list = List.of(doctors.value);
    final idx = list.indexWhere((d) => d['id'] == id);
    if (idx >= 0) {
      list[idx] = updated;
      doctors.value = list;
    }
  }

  void deleteDoctor(String id) {
    final list = List.of(doctors.value)..removeWhere((d) => d['id'] == id);
    doctors.value = list;
    // Optionally remove or reassign appointments
    final appts = List.of(appointments.value)..removeWhere((a) => a['doctorId'] == id);
    appointments.value = appts;
  }

  void rescheduleAppointment(String appointmentId, DateTime newDt) {
    final list = List.of(appointments.value);
    final idx = list.indexWhere((a) => a['id'] == appointmentId);
    if (idx >= 0) {
      final updated = Map.of(list[idx]);
      updated['datetime'] = newDt;
      list[idx] = updated;
      appointments.value = list;
    }
  }

  Map<String, dynamic>? getAppointmentById(String id) {
    try {
      return appointments.value.firstWhere((a) => a['id'] == id);
    } catch (_) {
      return null;
    }
  }

  void updateAppointment(String id, Map<String, dynamic> updated) {
    final list = List.of(appointments.value);
    final idx = list.indexWhere((a) => a['id'] == id);
    if (idx >= 0) {
      list[idx] = updated;
      appointments.value = list;
    }
  }

  void resolveAppointment(String id) {
    final list = List.of(appointments.value);
    final idx = list.indexWhere((a) => a['id'] == id);
    if (idx >= 0) {
      final updated = Map.of(list[idx]);
      updated['resolved'] = true;
      list[idx] = updated;
      appointments.value = list;
    }
  }

  // helper to format TimeOfDay
  static String formatTimeOfDay(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final ampm = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $ampm';
  }
}
