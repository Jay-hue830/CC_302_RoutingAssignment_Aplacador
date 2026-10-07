import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SampleItem {
  const SampleItem({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  factory SampleItem.fromJson(Map<String, dynamic> json) {
    return SampleItem(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  static const List<SampleItem> _fallbackItems = [
    SampleItem(
      id: 1,
      title: 'Morning task',
      body: 'Review the schedule and finish the pending work before noon.',
    ),
    SampleItem(
      id: 2,
      title: 'Project update',
      body: 'Check the latest design changes and make sure the team has the newest files.',
    ),
    SampleItem(
      id: 3,
      title: 'Study reminder',
      body: 'Read the notes again and prepare for the next class discussion.',
    ),
    SampleItem(
      id: 4,
      title: 'Daily goal',
      body: 'Complete one priority task and keep the rest of the list organized.',
    ),
  ];

  bool _isLoading = true;
  String? _errorMessage;
  List<SampleItem> _items = _fallbackItems;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load data: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as List;
      final loadedItems = decoded
          .map((item) => SampleItem.fromJson(item as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _items = loadedItems;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _items = _fallbackItems;
        _isLoading = false;
        _errorMessage = null;
      });
    }
  }

  void _deleteItem(int id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: Text('No items available.', style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(item.body, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _deleteItem(item.id),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
