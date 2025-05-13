// lib/blocs/mental_chat/bloc/mental_chat_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message.dart';

abstract class MentalChatState extends Equatable {
  const MentalChatState();

  @override
  List<Object> get props => [];
}

class MentalChatInitial extends MentalChatState {}
class MentalChatLoading extends MentalChatState {}
class MentalChatReady extends MentalChatState {
  final List<ChatMessage> messages;
  final Map<String, dynamic> userProfile;
  final Map<String, dynamic> lastSurvey;

  const MentalChatReady(this.messages, this.userProfile, this.lastSurvey);

  @override
  List<Object> get props => [messages, userProfile, lastSurvey];
}
class MentalChatError extends MentalChatState {
  final String message;
  const MentalChatError(this.message);

  @override
  List<Object> get props => [message];
}