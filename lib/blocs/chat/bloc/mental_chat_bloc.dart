// lib/blocs/chat/bloc/mental_chat_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../domain/entities/chat_message.dart';
import 'mental_chat_event.dart';
import 'mental_chat_state.dart';

class MentalChatBloc extends Bloc<MentalChatEvent, MentalChatState> {
  final FirebaseFirestore _firestore;
  late final GenerativeModel _model;
  late final SharedPreferences _prefs;
  String? _userId;
  Map<String, dynamic>? _userProfile;
  Map<String, dynamic>? _lastSurvey;
  final List<ChatMessage> _messages = [];

  MentalChatBloc(this._firestore) : super(MentalChatInitial()) {
    _initializeGemini();
    _initializePrefs();
    on<InitializeChat>(_onInitializeChat);
    on<SendMessage>(_onSendMessage);
  }

  void _initializeGemini() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-lite',
      apiKey: apiKey!,
    );
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _setupDailyCleanup();
  }

  void _setupDailyCleanup() {
    final lastCleanup = _prefs.getString('last_cleanup_date');
    final now = DateTime.now();
    final today = now.toIso8601String().split('T')[0];

    if (lastCleanup != today && now.hour >= 4) {
      _cleanupChat();
      _prefs.setString('last_cleanup_date', today);
    }
  }

  void _cleanupChat() {
    _prefs.remove('chat_messages');
    _messages.clear();
  }

  Future<void> _loadMessages() async {
    final messagesJson = _prefs.getString('chat_messages_${_userId}');
    if (messagesJson != null) {
      final List<dynamic> decoded = json.decode(messagesJson);
      _messages.clear();
      _messages.addAll(
        decoded.map((msg) => ChatMessage(
          text: msg['text'],
          isUser: msg['isUser'],
          timestamp: DateTime.parse(msg['timestamp']),
        )),
      );
    }
  }

  Future<void> _saveMessages() async {
    final messagesJson = json.encode(
      _messages.map((msg) => {
        'text': msg.text,
        'isUser': msg.isUser,
        'timestamp': msg.timestamp.toIso8601String(),
      }).toList(),
    );
    await _prefs.setString('chat_messages_${_userId}', messagesJson);
  }

  Future<void> _onInitializeChat(InitializeChat event, Emitter<MentalChatState> emit) async {
    try {
      emit(MentalChatLoading());
      _userId = event.userId;

      // Fetch user profile
      final profileDoc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('profile')
          .doc('data')
          .get();
      _userProfile = profileDoc.data();

      // Fetch last survey
      final surveysQuery = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('surveys_mood')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (surveysQuery.docs.isNotEmpty) {
        _lastSurvey = surveysQuery.docs.first.data();
      }

      // Load saved messages
      await _loadMessages();

      // Add initial bot message if there are no messages
      if (_messages.isEmpty) {
        final welcomeMessage = _generateWelcomeMessage();
        _messages.add(ChatMessage(
          text: welcomeMessage,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        await _saveMessages();
      }

      emit(MentalChatReady(_messages, _userProfile!, _lastSurvey!));
    } catch (e) {
      emit(MentalChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<MentalChatState> emit) async {
    try {
      _messages.add(ChatMessage(
        text: event.message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      await _saveMessages();

      emit(MentalChatReady(List.from(_messages), _userProfile!, _lastSurvey!));

      // Emit "typing..." state
      emit(MentalChatTyping(List.from(_messages), _userProfile!, _lastSurvey!));

      final response = await _generateResponse(event.message);

      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      await _saveMessages();

      emit(MentalChatReady(List.from(_messages), _userProfile!, _lastSurvey!));
    } catch (e) {
      emit(MentalChatError(e.toString()));
    }
  }

  String _generateWelcomeMessage() {
    final score = _lastSurvey?['score'] ?? 0;
    final mood = score < 5 ? "preocupado" : "positivo";
    return "Hola, soy Catarsis, tu apoyo psicológico por IA. "
           "Según tu última encuesta, noto que tu estado de ánimo está $mood. "
           "¿Cómo puedo ayudarte hoy?";
  }

  Future<String> _generateResponse(String userMessage) async {
    final prompt = '''
      Eres Catarsis, una inteligencia artificial empática y comprensiva diseñada para brindar acompañamiento emocional y bienestar mental. Tu misión es escuchar activamente, validar emociones y ofrecer orientación amable y útil, sin emitir juicios ni diagnósticos médicos. Eres cálida, paciente y conversas con el usuario como si fuera alguien a quien aprecias.
      
      Tu comportamiento debe reflejar:
      - Empatía genuina: responde de forma comprensiva y reconfortante.
      - Claridad: explicas ideas con suavidad y sin tecnicismos innecesarios.
      - Apoyo emocional: ayudas a reflexionar, pero nunca das órdenes.
      - Lenguaje accesible, humano y cercano, como una conversación tranquila.
      
      Adaptas tu respuesta al perfil del usuario:
      - Si el usuario es joven o estudiante, empleas ejemplos cotidianos o académicos.
      - Si el usuario expresa angustia o tristeza, priorizas el apoyo emocional.
      - Si pregunta sobre estrategias, ofreces técnicas de autocuidado, respiración, journaling, etc.
      - Siempre haces sentir al usuario acompañado.
      
      Nunca mencionas que eres un modelo de lenguaje o IA avanzada. Solo te identificas como "Catarsis".
      
      
      
      Recuerda: no das consejos médicos ni diagnósticos. Deriva con amabilidad al profesional adecuado si es necesario.
      
      al final del mensaje siempre da una solucion a lo que el usuario pregunta.
      
      maximo 4 parrafos.
      
      
      '''
        "Perfil del usuario: ${_userProfile.toString()}. "
        "Última encuesta de ánimo: ${_lastSurvey.toString()}. "
        "Mensaje del usuario: $userMessage";

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? "Lo siento, no pude generar una respuesta.";
  }
}