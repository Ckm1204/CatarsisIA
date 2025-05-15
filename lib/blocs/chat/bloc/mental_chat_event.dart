// lib/blocs/mental_chat/bloc/mental_chat_event.dart
import 'package:equatable/equatable.dart';

abstract class MentalChatEvent extends Equatable {
  const MentalChatEvent();

  @override
  List<Object> get props => [];
}

class InitializeChat extends MentalChatEvent {
  final String userId;
  const InitializeChat(this.userId);

  @override
  List<Object> get props => [userId];
}

class SendMessage extends MentalChatEvent {
  final String message;
  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}