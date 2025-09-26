import 'package:flutter/material.dart';
import '../../data/mock_repository.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final primary = const Color(0xFF1976D2);

  // Filters
  String stockStatus = 'All'; // In Stock, Low Stock, Out of Stock
  String stockType = 'All'; // Expiring Soon, Expired, Long-Term
  String category = 'All';
  String form = 'All';

  bool _matchesFilters(Map<String, dynamic> item) {
    final qty = item['quantity'] as int? ?? 0;
    final sType = (item['stockType'] as String?) ?? '';
    final cat = (item['category'] as String?) ?? '';
    final f = (item['form'] as String?) ?? '';

    if (stockStatus == 'In Stock' && qty <= 0) return false;
    if (stockStatus == 'Low Stock' && qty > 50) return false;
    if (stockStatus == 'Out of Stock' && qty > 0) return false;

    if (stockType != 'All' && sType != stockType) return false;
    if (category != 'All' && cat != category) return false;
    if (form != 'All' && f != form) return false;

    return true;
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'N/A';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Med - Admin'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: const SizedBox.shrink(),
      body: Column(
        children: [
          // Blue header
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Text(
                'Inventory',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ExpansionTile(
              title: const Text('Filters'),
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    DropdownButton<String>(
                      value: stockStatus,
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(
                          value: 'In Stock',
                          child: Text('In Stock'),
                        ),
                        DropdownMenuItem(
                          value: 'Low Stock',
                          child: Text('Low Stock'),
                        ),
                        DropdownMenuItem(
                          value: 'Out of Stock',
                          child: Text('Out of Stock'),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => stockStatus = v ?? 'All'),
                    ),
                    DropdownButton<String>(
                      value: stockType,
                      items: const [
                        DropdownMenuItem(
                          value: 'All',
                          child: Text('All Types'),
                        ),
                        DropdownMenuItem(
                          value: 'Expiring Soon',
                          child: Text('Expiring Soon'),
                        ),
                        DropdownMenuItem(
                          value: 'Expired',
                          child: Text('Expired'),
                        ),
                        DropdownMenuItem(
                          value: 'Long-Term',
                          child: Text('Long-Term'),
                        ),
                      ],
                      onChanged: (v) => setState(() => stockType = v ?? 'All'),
                    ),
                    DropdownButton<String>(
                      value: category,
                      items: const [
                        DropdownMenuItem(
                          value: 'All',
                          child: Text('All Categories'),
                        ),
                        DropdownMenuItem(
                          value: 'Antibiotics',
                          child: Text('Antibiotics'),
                        ),
                        DropdownMenuItem(
                          value: 'Analgesics',
                          child: Text('Analgesics'),
                        ),
                        DropdownMenuItem(
                          value: 'Antihypertensives',
                          child: Text('Antihypertensives'),
                        ),
                        DropdownMenuItem(
                          value: 'Antivirals',
                          child: Text('Antivirals'),
                        ),
                        DropdownMenuItem(
                          value: 'Antifungals',
                          child: Text('Antifungals'),
                        ),
                        DropdownMenuItem(
                          value: 'Inhalers/Injectables',
                          child: Text('Inhalers/Injectables'),
                        ),
                        DropdownMenuItem(
                          value: 'Respiratory',
                          child: Text('Respiratory'),
                        ),
                        DropdownMenuItem(
                          value: 'Cardiac',
                          child: Text('Cardiac'),
                        ),
                        DropdownMenuItem(
                          value: 'Supplements',
                          child: Text('Supplements'),
                        ),
                        DropdownMenuItem(
                          value: 'Antidiabetics',
                          child: Text('Antidiabetics'),
                        ),
                        DropdownMenuItem(
                          value: 'IV Fluids',
                          child: Text('IV Fluids'),
                        ),
                      ],
                      onChanged: (v) => setState(() => category = v ?? 'All'),
                    ),
                    DropdownButton<String>(
                      value: form,
                      items: const [
                        DropdownMenuItem(
                          value: 'All',
                          child: Text('All Forms'),
                        ),
                        DropdownMenuItem(
                          value: 'Capsule',
                          child: Text('Capsule'),
                        ),
                        DropdownMenuItem(
                          value: 'Tablet',
                          child: Text('Tablet'),
                        ),
                        DropdownMenuItem(value: 'Syrup', child: Text('Syrup')),
                        DropdownMenuItem(value: 'IV', child: Text('IV')),
                        DropdownMenuItem(
                          value: 'Inhaler',
                          child: Text('Inhaler'),
                        ),
                        DropdownMenuItem(
                          value: 'Bottle',
                          child: Text('Bottle'),
                        ),
                        DropdownMenuItem(
                          value: 'Injectable',
                          child: Text('Injectable'),
                        ),
                      ],
                      onChanged: (v) => setState(() => form = v ?? 'All'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: MockRepository.instance.inventory,
                builder: (context, list, _) {
                  final filtered = list
                      .where((i) => _matchesFilters(i))
                      .toList();
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80, top: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final qty = item['quantity'] as int? ?? 0;
                      final unit = item['unit'] as String? ?? '';
                      final exp = item['expires'] as DateTime?;
                      final lowStock = qty <= 50;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item['name']} ${item['dosage'] ?? ''}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (lowStock)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'LOW STOCK',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Qty: $qty $unit  •  Expires: ${_formatDate(exp)}',
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      '/editInventory',
                                      arguments: item,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () {
                                      MockRepository.instance
                                          .deleteInventoryItem(
                                            item['id'] as String,
                                          );
                                    },
                                    child: const Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addInventory'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
