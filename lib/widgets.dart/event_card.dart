import 'package:event_explorer/widgets.dart/shimmer.dart';
import 'package:event_explorer/widgets.dart/webview.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Item item;
  final bool isLoading;
  final bool gridView;

  const EventCard({
    Key? key,
    required this.item,
    this.isLoading = false,
    this.gridView = false,
  });

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 200.0;
    const double fontSize = 12.0;
    final int flex = gridView ? 7 : 20;

    Decoration? decoration =
        item.bannerUrl != null && item.bannerUrl!.isNotEmpty
            ? BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(item.bannerUrl ?? ""),
                  fit: gridView ? BoxFit.contain : BoxFit.cover,
                ),
              )
            : null;

    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          if (isLoading) return;

          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => WebViewScreen(
          //     item: item,
          //   ),
          // ));

          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(
                  milliseconds: 500), // Adjust animation duration as needed
              pageBuilder: (context, animation, secondaryAnimation) =>
                  WebViewScreen(
                item: item,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, page) {
                // Scale animation
                var begin = 0.8;
                var end = 1.0;
                var curve = Curves.easeInOut;
                var scaleTween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                // Fade animation
                var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

                // Combine scale and fade animations
                return ScaleTransition(
                  scale: animation.drive(scaleTween),
                  child: FadeTransition(
                    opacity: animation.drive(fadeTween),
                    child: page,
                  ),
                );
              },
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShimmerLoading(
                isLoading: isLoading,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20.0)),
                  child: Container(
                    height: imageHeight,
                    decoration: decoration,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Icon(Icons.access_time,
                                    color: Colors.white),
                              ),
                              const Expanded(child: SizedBox(width: 5)),
                              Expanded(
                                flex: flex,
                                child: Text(
                                  item.startTimeDisplay ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: fontSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Expanded(
                                child: Icon(Icons.location_on,
                                    color: Colors.white),
                              ),
                              const Expanded(child: SizedBox(width: 5)),
                              Expanded(
                                flex: flex,
                                child: Text(
                                  item.location ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: fontSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ShimmerLoading(
                      isLoading: isLoading,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.eventnameRaw ?? "",
                          style: const TextStyle(
                            fontSize: fontSize + 3,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
