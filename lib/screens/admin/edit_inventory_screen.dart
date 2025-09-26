import 'package:flutter/material.dart';
import '../../data/mock_repository.dart';

class EditInventoryScreen extends StatefulWidget {
  const EditInventoryScreen({Key? key}) : super(key: key);

  @override
  State<EditInventoryScreen> createState() => _EditInventoryScreenState();
}

class _EditInventoryScreenState extends State<EditInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> item;
  final primary = const Color(0xFF1976D2);

  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final qtyController = TextEditingController();
  DateTime? expires;
  String category = 'Antibiotics';
  String form = 'Capsule';
  String stockType = 'Long-Term';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    item = args != null ? Map.of(args) : {};
    nameController.text = item['name'] as String? ?? '';
    dosageController.text = item['dosage'] as String? ?? '';
    qtyController.text = (item['quantity'] as int?)?.toString() ?? '';
    expires = item['expires'] as DateTime?;
    category = item['category'] as String? ?? category;
    form = item['form'] as String? ?? form;
    stockType = item['stockType'] as String? ?? stockType;
  }

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
                  final d = await showDatePicker(context: context, initialDate: expires ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                  if (d != null) setState(() => expires = d);
                },
                child: Text('Expires: ${expires != null ? '${expires!.year}-${expires!.month.toString().padLeft(2, '0')}-${expires!.day.toString().padLeft(2, '0')}' : 'Select Date'}'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: [
                  DropdownMenuItem(value: 'Antibiotics', child: Text('Antibiotics')),
                  DropdownMenuItem(value: 'Analgesics', child: Text('Analgesics')),
                  DropdownMenuItem(value: 'Antihypertensives', child: Text('Antihypertensives')),
                  DropdownMenuItem(value: 'Antivirals', child: Text('Antivirals')),
                  DropdownMenuItem(value: 'Antifungals', child: Text('Antifungals')),
                  DropdownMenuItem(value: 'Inhalers/Injectables', child: Text('Inhalers/Injectables')),
                ],
                onChanged: (v) => setState(() => category = v ?? category),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: form,
                items: [
                  DropdownMenuItem(value: 'Capsule', child: Text('Capsule')),
                  DropdownMenuItem(value: 'Tablet', child: Text('Tablet')),
                  DropdownMenuItem(value: 'Syrup', child: Text('Syrup')),
                  DropdownMenuItem(value: 'IV', child: Text('IV')),
                  DropdownMenuItem(value: 'Inhaler/Spray', child: Text('Inhaler/Spray')),
                  DropdownMenuItem(value: 'Injectable', child: Text('Injectable')),
                ],
                onChanged: (v) => setState(() => form = v ?? form),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: stockType,
                items: [
                  DropdownMenuItem(value: 'Expiring Soon', child: Text('Expiring Soon')),
                  DropdownMenuItem(value: 'Expired', child: Text('Expired')),
                  DropdownMenuItem(value: 'Long-Term', child: Text('Long-Term')),
                ],
                onChanged: (v) => setState(() => stockType = v ?? stockType),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      MockRepository.instance.deleteInventoryItem(item['id'] as String);
                      Navigator.pop(context);
                    },
                    child: const Text('Delete Stock', style: TextStyle(color: Colors.red)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final updated = Map.of(item);
                      updated['name'] = nameController.text;
                      updated['dosage'] = dosageController.text;
                      updated['quantity'] = int.tryParse(qtyController.text) ?? (item['quantity'] as int? ?? 0);
                      updated['expires'] = expires;
                      updated['category'] = category;
                      updated['form'] = form;
                      updated['stockType'] = stockType;
                      MockRepository.instance.updateInventoryItem(item['id'] as String, updated);
                      Navigator.pop(context);
                    },
                    child: const Text('Save Changes'),
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
