import 'package:flutter/material.dart';
import '../../data/mock_repository.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({Key? key}) : super(key: key);

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final qtyController = TextEditingController();
  DateTime? expires;
  String category = 'Antibiotics';
  String form = 'Capsule';
  String stockType = 'Long-Term';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Med - Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: nameController, decoration: InputDecoration(labelText: 'Medicine Name', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 12),
              TextFormField(controller: dosageController, decoration: InputDecoration(labelText: 'Dosage', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 12),
              TextFormField(controller: qtyController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Quantity', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                  if (d != null) setState(() => expires = d);
                },
                child: Text('Expires: ${expires != null ? '${expires!.year}-${expires!.month.toString().padLeft(2, '0')}-${expires!.day.toString().padLeft(2, '0')}' : 'Select Date'}'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: category, items: const [
                DropdownMenuItem(value: 'Antibiotics', child: Text('Antibiotics')),
                DropdownMenuItem(value: 'Analgesics', child: Text('Analgesics')),
                DropdownMenuItem(value: 'Antihypertensives', child: Text('Antihypertensives')),
                DropdownMenuItem(value: 'Antivirals', child: Text('Antivirals')),
                DropdownMenuItem(value: 'Antifungals', child: Text('Antifungals')),
                DropdownMenuItem(value: 'Inhalers/Injectables', child: Text('Inhalers/Injectables')),
              ], onChanged: (v) => setState(() => category = v ?? category)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: form, items: const [
                DropdownMenuItem(value: 'Capsule', child: Text('Capsule')),
                DropdownMenuItem(value: 'Tablet', child: Text('Tablet')),
                DropdownMenuItem(value: 'Syrup', child: Text('Syrup')),
                DropdownMenuItem(value: 'IV', child: Text('IV')),
                DropdownMenuItem(value: 'Inhaler/Spray', child: Text('Inhaler/Spray')),
                DropdownMenuItem(value: 'Injectable', child: Text('Injectable')),
              ], onChanged: (v) => setState(() => form = v ?? form)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: stockType, items: const [
                DropdownMenuItem(value: 'Expiring Soon', child: Text('Expiring Soon')),
                DropdownMenuItem(value: 'Expired', child: Text('Expired')),
                DropdownMenuItem(value: 'Long-Term', child: Text('Long-Term')),
              ], onChanged: (v) => setState(() => stockType = v ?? stockType)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final newItem = {
                        'id': 'i' + DateTime.now().millisecondsSinceEpoch.toString(),
                        'name': nameController.text,
                        'dosage': dosageController.text,
                        'quantity': int.tryParse(qtyController.text) ?? 0,
                        'unit': 'units',
                        'expires': expires,
                        'category': category,
                        'form': form,
                        'stockType': stockType,
                      };
                      MockRepository.instance.addInventoryItem(newItem);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(140, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Save'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
