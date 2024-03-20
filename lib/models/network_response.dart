import 'package:equatable/equatable.dart';

class ResponseModel extends Equatable {
  // ignore: prefer_typing_uninitialized_variables
  final statusCode;
  final data;

  const ResponseModel({this.statusCode, this.data});

  List<Object?> get props => [statusCode, data];
}
