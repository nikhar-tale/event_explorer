import 'package:event_explorer/bloc/event_bloc.dart';
import 'package:event_explorer/bloc/event_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event_state.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../widgets.dart/event_card.dart';

class ListingScreen extends StatefulWidget {
  final Category category;

  const ListingScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final EventBloc eventBloc = EventBloc();
  bool _isListView = true; // Track the current view mode

  @override
  void initState() {
    super.initState();
    eventBloc.add(FetchEventsByCategory(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.category ?? ''),
        actions: [
          IconButton(
            icon: Icon(_isListView ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                _isListView = !_isListView;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<EventBloc, EventState>(
        bloc: eventBloc,
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventLoaded) {
            Event _event = state.events;

            return _isListView
                ? _buildListView(_event.item!)
                : _buildGridView(_event.item!);
          } else if (state is EventError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildListView(List<Item> items) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Container(
          height: 10,
        );
      },
      itemCount: items.length,
      itemBuilder: (context, index) {
        final Item item = items[index];
        return EventCard(item: item);
      },
    );
  }

  Widget _buildGridView(List<Item> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75, // Adjust as needed
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final Item item = items[index];
        return EventCard(item: item);
      },
    );
  }
}
