// event_bloc.dart

import 'package:event_explorer/models/network_response.dart';
import 'package:event_explorer/services/network_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/category.dart';
import '../models/event.dart';
import '../services/test_env.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final NetworkService networkService = NetworkService();
  final TestEnv testEnv = TestEnv();
  EventBloc() : super(EventLoading()) {
    on<EventEvent>((event, emit) async {
      if (event is FetchCategories) {
        try {
          List<Category> categories = await fetchCategories();

          emit(CategoriesLoaded(categories: categories));
        } catch (e) {
          emit(EventError('Failed to fetch Categories: $e'));
        }
      }

      if (event is FetchEventsByCategory) {
        try {
          Event events = await fetchEventsByCategory(event);

          emit(EventLoaded(events: events));
        } catch (e) {
          emit(EventError('Failed to fetch Categories: $e'));
        }
      }
    });
  }

  Future<List<Category>> fetchCategories() async {
    try {
      ResponseModel response =
          await networkService.get(testEnv.testCategoriesURL);

      if (response.statusCode == 200) {
        return response.data
            .map<Category>((i) => Category.fromJson(i))
            .toList();
      }
      throw (response.statusCode);
    } catch (e) {
      throw (e);
    }
  }

  fetchEventsByCategory(FetchEventsByCategory event) async {
    try {
      String _url = event.category.data!;
      ResponseModel response = await networkService.get(_url);

      if (response.statusCode == 200) {
        return Event.fromJson(response.data);
      }
      throw (response.statusCode);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
