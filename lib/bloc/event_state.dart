import '../models/category.dart';
import '../models/event.dart';

abstract class EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final Event events;

  EventLoaded({required this.events});
}

class CategoriesLoaded extends EventState {
  final List<Category> categories;

  CategoriesLoaded({required this.categories});
}

class EventError extends EventState {
  final String errorMessage;

  EventError(this.errorMessage);
}
