import 'package:event_explorer/bloc/event_bloc.dart';
import 'package:event_explorer/bloc/event_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event_state.dart';
import '../models/category.dart';

class ListingScreen extends StatefulWidget {
  final Category category;

  const ListingScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final EventBloc eventBloc = EventBloc();

  @override
  void initState() {
    super.initState();
    // Access the EventBloc

    // Add FetchEvents event to fetch the events for the selected category
    eventBloc.add(FetchEventsByCategory(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events in ${widget.category.category}'),
      ),
      body: BlocBuilder<EventBloc, EventState>(
        bloc: eventBloc,
        builder: (context, state) {
          if (state is EventLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventLoaded) {
            return Text(state.events.request!.category ?? '');
          } else if (state is EventError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  // Widget _buildEventList(List<Event> events) {
  //   // This function builds the list of events based on the current state
  //   return ListView.builder(
  //     itemCount: events.length,
  //     itemBuilder: (context, index) {
  //       final event = events[index];
  //       return ListTile(
  //         title: Text(event.name),
  //         subtitle: Text(event.date),
  //         // Navigate to event details screen on tap
  //         onTap: () {
  //           // Add navigation logic here
  //         },
  //       );
  //     },
  //   );
  // }
}
