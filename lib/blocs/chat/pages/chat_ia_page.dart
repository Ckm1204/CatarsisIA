// lib/blocs/chat/pages/chat_ia_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/mental_chat_bloc.dart';
import '../bloc/mental_chat_state.dart';
import '../bloc/mental_chat_event.dart';

class ChatIAPage extends StatefulWidget {
  const ChatIAPage({Key? key}) : super(key: key);

  @override
  State<ChatIAPage> createState() => _ChatIAPageState();
}
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({Key? key}) : super(key: key);

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dots;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _dots = IntTween(begin: 1, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dots,
      builder: (context, child) {
        final dotsStr = '.' * _dots.value;
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text('Catarsis está escribiendo$dotsStr'),
          ),
        );
      },
    );
  }
}


class _ChatIAPageState extends State<ChatIAPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final User? currentUser = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _handleSend(BuildContext context) {
    if (_messageController.text.trim().isNotEmpty) {
      context
          .read<MentalChatBloc>()
          .add(SendMessage(_messageController.text.trim()));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login to access the chat'),
        ),
      );
    }

    return BlocProvider(
      create: (context) {
        final bloc = MentalChatBloc(FirebaseFirestore.instance);
        bloc.add(InitializeChat(currentUser!.uid));
        return bloc;
      },
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Catarsis - Apoyo Psicológico'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: BlocConsumer<MentalChatBloc, MentalChatState>(
            listener: (context, state) {
              if (state is MentalChatReady) {
                Future.delayed(const Duration(milliseconds: 1), () {
                  _scrollToBottom();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
                });
              }
            },
            builder: (context, state) {
              if (state is MentalChatLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is MentalChatError) {
                return Center(child: Text('Error: ${state.message}'));
              }


              if (state is MentalChatTyping || state is MentalChatReady) {
                final messages = (state is MentalChatTyping)
                    ? state.messages
                    : (state as MentalChatReady).messages;

                final isTyping = state is MentalChatTyping;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length + (isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (isTyping && index == messages.length) {
                            return const _TypingIndicator();
                          }
                          final message = messages[index];
                          return _ChatBubble(
                            message: message.text,
                            isUser: message.isUser,
                          );
                        },
                      ),
                    ),
                    _buildMessageInput(context),
                  ],
                );
              }


              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Deshaogate aquí...',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _handleSend(context),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: () => _handleSend(context),
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const _ChatBubble({
    required this.message,
    required this.isUser,
  });

  List<TextSpan> _parseText(String text, TextStyle baseStyle) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int currentPosition = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before the match
      if (match.start > currentPosition) {
        spans.add(TextSpan(
          text: text.substring(currentPosition, match.start),
          style: baseStyle,
        ));
      }

      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: baseStyle.copyWith(fontWeight: FontWeight.bold),
      ));

      currentPosition = match.end;
    }

    // Add remaining text
    if (currentPosition < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPosition),
        style: baseStyle,
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: isUser
          ? Colors.white
          : Theme.of(context).colorScheme.onSecondaryContainer,
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: RichText(
          text: TextSpan(
            children: _parseText(message, textStyle),
          ),
        ),
      ),
    );
  }
}