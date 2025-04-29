// lib/modules/home/bloc/home_event.dart
abstract class HomeEvent {
  const HomeEvent();
}

class NavigationIndexChanged extends HomeEvent {
  final int index;
  const NavigationIndexChanged(this.index);
}