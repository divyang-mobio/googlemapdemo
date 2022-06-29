part of 'datafetch_bloc.dart';

abstract class DatafetchState {}

class DatafetchInitial extends DatafetchState {}

class DatafetchLoaded extends DatafetchState {
  final List<LocationData> data;
  DatafetchLoaded({required this.data});
}
