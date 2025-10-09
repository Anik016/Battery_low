import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onSelectChat;
  const Sidebar({super.key, required this.onSelectChat});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late Box _chatsBox;
  String _currentChatId = "";

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _chatsBox = await Hive.openBox('chats');
    if (_chatsBox.isNotEmpty) {
      _currentChatId = _chatsBox.keys.last;
    }
    setState(() {});
  }

  void _createNewChat() async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _chatsBox.put(id, []); // empty chat
    setState(() {
      _currentChatId = id;
    });
    widget.onSelectChat(id);
  }

  void _selectChat(String id) {
    setState(() {
      _currentChatId = id;
    });
    widget.onSelectChat(id);
  }

  @override
  Widget build(BuildContext context) {
    final keys = _chatsBox.keys.toList();

    return Container(
      width: 260,
      color: Colors.grey.shade900,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text("🧠 Local AI Chat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.grey),
          Expanded(
            child: ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, i) {
                final id = keys[i];
                return ListTile(
                  title: Text("Chat ${i + 1}"),
                  selected: id == _currentChatId,
                  selectedTileColor: Colors.blue.shade700,
                  onTap: () => _selectChat(id),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("New Chat"),
            onPressed: _createNewChat,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
