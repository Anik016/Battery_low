import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import 'sidebar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Box _chatsBox;
  String _currentChatId = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _chatsBox = await Hive.openBox('chats');
    if (_chatsBox.isNotEmpty) {
      _currentChatId = _chatsBox.keys.last;
      _loadMessages();
    }
  }

  Future<void> _loadMessages() async {
    final stored = _chatsBox.get(_currentChatId, defaultValue: []);
    setState(() {
      _messages = (stored as List)
          .map((e) => Message.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  Future<void> _saveMessages() async {
    await _chatsBox.put(
        _currentChatId, _messages.map((e) => e.toJson()).toList());
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _controller.clear();
      _isLoading = true;
    });

    await _saveMessages();

    final reply = await ChatService.getResponse(_messages, text);

    setState(() {
      _messages.add(Message(text: reply, isUser: false));
      _isLoading = false;
    });

    await _saveMessages();

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _selectChat(String chatId) async {
    _currentChatId = chatId;
    await _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            onSelectChat: _selectChat,
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: const Text("Local AI Chat"),
                  automaticallyImplyLeading: false,
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? Colors.blueGrey.shade800
                                : Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: MarkdownBody(
                            data: msg.text,
                            selectable: true,
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(fontSize: 16),
                              codeblockDecoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey.shade900,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Message Local AI...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.black45,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
