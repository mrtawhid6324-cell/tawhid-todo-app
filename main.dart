import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tawhid Todo',
      theme: ThemeData.dark(),
      home: TodoListScreen(),
    );
  }
}

class TodoItem {
  String title;
  bool isDone;
  String? time;

  TodoItem({required this.title, this.isDone = false, this.time});
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todoItems = [];
  String _searchQuery = "";

  void _addTodoItem(String title, String? time) {
    if (title.isNotEmpty) {
      setState(() {
        _todoItems.add(TodoItem(title: title, time: time));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TodoItem> filteredItems = _todoItems.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    int completedCount = _todoItems.where((item) => item.isDone).length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1F1F1F), Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text('তাওহীদের ডার্ক টু-ডু', 
                  style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orange.shade900]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text("অগ্রগতি: $completedCount / ${_todoItems.length}", 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "কাজ খুঁজুন...",
                    prefixIcon: Icon(Icons.search, color: Colors.amber),
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ),
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(child: Text("কোনো কাজ নেই!"))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            color: Colors.white.withOpacity(0.05),
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: Colors.amber,
                                value: item.isDone,
                                onChanged: (bool? value) => setState(() => item.isDone = value!),
                              ),
                              title: Text(item.title, style: TextStyle(color: item.isDone ? Colors.grey : Colors.white)),
                              subtitle: item.time != null ? Text(item.time!, style: TextStyle(color: Colors.amber, fontSize: 11)) : null,
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("Developed by TAWHID", style: TextStyle(color: Colors.amber.withOpacity(0.5), fontSize: 10)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.amber,
        onPressed: () => _displayDialog(),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _displayDialog() async {
    TextEditingController _controller = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          title: Text('নতুন কাজ', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller, 
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: "কাজের নাম লিখুন"),
              ),
              SizedBox(height: 10),
              TextButton.icon(
                icon: Icon(Icons.access_time, color: Colors.amber),
                label: Text(selectedTime == null ? "সময় সেট করুন" : selectedTime!.format(context), style: TextStyle(color: Colors.amber)),
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (time != null) setDialogState(() => selectedTime = time);
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                _addTodoItem(_controller.text, selectedTime?.format(context));
                Navigator.pop(context);
              },
              child: Text('সেভ', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
