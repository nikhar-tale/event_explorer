import 'package:event_explorer/models/category.dart';

abstract class EventEvent {}

class FetchCategories extends EventEvent {}

class FetchEventsByCategory extends EventEvent {
  final Category category;

  FetchEventsByCategory(this.category);
}
