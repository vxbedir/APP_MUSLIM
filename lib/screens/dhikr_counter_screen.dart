import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DhikrCounterScreen extends StatefulWidget {
  const DhikrCounterScreen({super.key});

  @override
  State<DhikrCounterScreen> createState() => _DhikrCounterScreenState();
}

class _DhikrCounterScreenState extends State<DhikrCounterScreen> {
  List<DhikrCounter> _counters = [];
  
  @override
  void initState() {
    super.initState();
    _loadCounters();
  }
  
  Future<void> _loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final countersJson = prefs.getStringList('dhikr_counters') ?? [];
    
    setState(() {
      _counters = countersJson.map((json) => DhikrCounter.fromJson(json)).toList();
      
      // Add default counters if none exist
      if (_counters.isEmpty) {
        _counters = [
          DhikrCounter(
            id: '1',
            name: 'Subhanallah',
            arabicText: 'سبحان الله',
            target: 33,
          ),
          DhikrCounter(
            id: '2',
            name: 'Alhamdulillah',
            arabicText: 'الحمد لله',
            target: 33,
          ),
          DhikrCounter(
            id: '3',
            name: 'Allahu Akbar',
            arabicText: 'الله أكبر',
            target: 34,
          ),
        ];
        _saveCounters();
      }
    });
  }
  
  Future<void> _saveCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final countersJson = _counters.map((counter) => counter.toJson()).toList();
    await prefs.setStringList('dhikr_counters', countersJson);
  }
  
  void _incrementCounter(int index) {
    setState(() {
      _counters[index].count++;
      // Log counter increment for debugging
      // Removed print statement from production code
    });
    _saveCounters();
  }
  
  void _resetCounter(int index) {
    setState(() {
      _counters[index].count = 0;
      // Log counter reset for debugging
      // Removed print statement from production code
    });
    _saveCounters();
  }
  
  Future<void> _addCounter() async {
    final result = await showDialog<DhikrCounter>(
      context: context,
      builder: (context) => const _AddDhikrDialog(),
    );
    
    if (result != null) {
      setState(() {
        _counters.add(result);
      });
      _saveCounters();
    }
  }
  
  Future<void> _editCounter(int index) async {
    final result = await showDialog<DhikrCounter>(
      context: context,
      builder: (context) => _AddDhikrDialog(counter: _counters[index]),
    );
    
    if (result != null) {
      setState(() {
        _counters[index] = result;
      });
      _saveCounters();
    }
  }
  
  void _deleteCounter(int index) {
    setState(() {
      _counters.removeAt(index);
    });
    _saveCounters();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addCounter,
        child: const Icon(Icons.add),
      ),
      body: _counters.isEmpty
                ? const Center(child: Text('No dhikr counters added yet.'))
                : ListView.builder(
                  itemCount: _counters.length,
                  itemBuilder: (context, index) {
                    final counter = _counters[index];
                    final progress = counter.count / counter.target;
                    
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  counter.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _editCounter(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _deleteCounter(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.refresh),
                                      onPressed: () => _resetCounter(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              counter.arabicText,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: progress > 1 ? 1 : progress,
                              minHeight: 10,
                            ),
                            const SizedBox(height: 8),
                            Text('${counter.count} / ${counter.target}'),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => _incrementCounter(index),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                                  shape: const CircleBorder(),
                                ),
                                child: Center(
                                  child: Text(
                                    counter.count.toString(),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class DhikrCounter {
  final String id;
  final String name;
  final String arabicText;
  final int target;
  int count;

  DhikrCounter({
    required this.id,
    required this.name,
    required this.arabicText,
    required this.target,
    this.count = 0,
  });

  factory DhikrCounter.fromJson(String json) {
    final parts = json.split('|');
    return DhikrCounter(
      id: parts[0],
      name: parts[1],
      arabicText: parts[2],
      target: int.parse(parts[3]),
      count: int.parse(parts[4]),
    );
  }

  String toJson() {
    return '$id|$name|$arabicText|$target|$count';
  }
}

class _AddDhikrDialog extends StatefulWidget {
  final DhikrCounter? counter;
  
  const _AddDhikrDialog({this.counter});

  @override
  State<_AddDhikrDialog> createState() => _AddDhikrDialogState();
}

class _AddDhikrDialogState extends State<_AddDhikrDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _arabicTextController = TextEditingController();
  final _targetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.counter != null) {
      _nameController.text = widget.counter!.name;
      _arabicTextController.text = widget.counter!.arabicText;
      _targetController.text = widget.counter!.target.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _arabicTextController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.counter == null ? 'Add Dhikr Counter' : 'Edit Dhikr Counter'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g., Subhanallah',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _arabicTextController,
                decoration: const InputDecoration(
                  labelText: 'Arabic Text',
                  hintText: 'e.g., سبحان الله',
                ),
                textDirection: TextDirection.rtl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Arabic text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _targetController,
                decoration: const InputDecoration(
                  labelText: 'Target Count',
                  hintText: 'e.g., 33',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target count';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final counter = DhikrCounter(
                id: widget.counter?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                arabicText: _arabicTextController.text,
                target: int.parse(_targetController.text),
                count: widget.counter?.count ?? 0,
              );
              Navigator.of(context).pop(counter);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
