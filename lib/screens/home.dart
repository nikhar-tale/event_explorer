import 'package:event_explorer/models/category.dart';
import 'package:event_explorer/screens/listing.dart';
import 'package:event_explorer/widgets.dart/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventBloc eventBloc = EventBloc();

  String sectionTitle = 'Categories';

  @override
  void initState() {
    super.initState();
    // Access the EventBloc

    // Add FetchEvents event to fetch the events
    eventBloc.add(FetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sectionTitle),
      ),
      body: BlocBuilder<EventBloc, EventState>(
        bloc: eventBloc,
        builder: (context, state) {
          if (state is EventLoading) {
            // Display shimmer loading effect
            return _buildShimmerLoading();
          } else if (state is CategoriesLoaded) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final Category category = state.categories[index];
                return _buildCategoryCard(category);
              },
            );
          } else if (state is EventError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    // Use category name to fetch icon dynamically
    IconData iconData = Utils.getCategoryIcon(category.category ?? '');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to events of the selected category
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListingScreen(
                      category: category,
                    )));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    iconData,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  category.category ?? 'Unknown Category',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build shimmer loading effect
  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ShimmerLoading(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: double.infinity,
                height: 24,
              ),
            ),
          ),
        );
      },
    );
  }

  String _capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
}
