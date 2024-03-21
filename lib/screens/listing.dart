import 'package:event_explorer/bloc/event_bloc.dart';
import 'package:event_explorer/bloc/event_event.dart';
import 'package:event_explorer/utils/utils.dart';
import 'package:event_explorer/widgets.dart/shimmer.dart';

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
  ScrollController? listViwController = ScrollController();
  ScrollController? grideViwController = ScrollController();
  // Track the current view mode

  @override
  void initState() {
    super.initState();
    eventBloc.add(FetchEventsByCategory(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: BlocBuilder<EventBloc, EventState>(
        bloc: eventBloc,
        builder: (context, state) {
          if (state is EventLoading) {
            Event event = Event(
                count: 4,
                request: Request(),
                item: [Item(), Item(), Item(), Item()]);

            Widget listview = _buildListView(event: event, isLoading: true);
            Widget gridview = _buildGridView(event: event, isLoading: true);

            return ValueListenableBuilder<bool>(
                valueListenable: Utils.isListView,
                builder: (BuildContext context, bool value, child) {
                  if (Utils.isListView.value) {
                    return listview;
                  }
                  return gridview;
                });
          } else if (state is EventLoaded) {
            Event event = state.events;

            Widget listview = _buildListView(
              event: event,
            );
            Widget gridview = _buildGridView(
              event: event,
            );

            return ValueListenableBuilder<bool>(
                valueListenable: Utils.isListView,
                builder: (BuildContext context, bool value, child) {
                  if (Utils.isListView.value) {
                    return listview;
                  }
                  return gridview;
                });
          } else if (state is EventError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildListView({required Event event, bool isLoading = false}) {
    List<Item> items = event.item ?? [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eventDetails(event: event, isLoading: isLoading),
        Expanded(
          child: ListView.separated(
            controller: listViwController,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            separatorBuilder: (context, index) {
              return Container(
                height: 10,
              );
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              final Item item = items[index];
              return EventCard(
                item: item,
                isLoading: isLoading,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGridView({required Event event, bool isLoading = false}) {
    List<Item> items = event.item ?? [];
    return Column(
      children: [
        eventDetails(event: event, isLoading: isLoading),
        Expanded(
          child: GridView.builder(
            controller: grideViwController,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 8,
              childAspectRatio: 0.60, // Adjust as needed
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final Item item = items[index];
              return EventCard(
                item: item,
                isLoading: isLoading,
                gridView: true,
              );
            },
          ),
        ),
      ],
    );
  }

  appbar() {
    IconData iconData = Utils.getCategoryIcon(widget.category!.category ?? '');
    return AppBar(
      // Set your preferred background color
      elevation: 4, // Set elevation for a slight shadow
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ), // You can use any icon for your menu
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      titleSpacing: 0,
      title: Hero(
        transitionOnUserGestures: true,
        tag: widget.category.category ?? 'Unknown Category',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(88, 44, 3, 115),
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              (widget.category.category ?? ''),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color
              ),
            ),
          ],
        ),
      ),
      actions: [
        ValueListenableBuilder<bool>(
            valueListenable: Utils.isListView,
            builder: (BuildContext context, bool value, child) {
              return IconButton(
                icon: Icon(Utils.isListView.value
                    ? Icons.grid_view_sharp
                    : Icons.list_rounded),
                onPressed: () {
                  Utils.isListView.value = !Utils.isListView.value;
                },
              );
            }),
      ],
    );
  }

  eventDetails({required Event event, bool isLoading = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShimmerLoading(
                    isLoading: isLoading,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ShimmerLoading(
                    isLoading: isLoading,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Events Around ${Utils.capitalizeFirstLetter(event.request!.cityDisplay ?? "")}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ShimmerLoading(
                isLoading: isLoading,
                child: SizedBox(
                  height: 22,
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(190, 104, 58, 183),
                    child: Text(
                      '${event.count}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Add more icons and text as needed
        ],
      ),
    );
  }
}
