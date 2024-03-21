import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_explorer/bloc/event_bloc.dart';
import 'package:event_explorer/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Your App Title',
        home: HomeScreen(),
      ),
    );
  }
}
