part of 'datafetch_bloc.dart';

abstract class DatafetchEvent {}

class NoteInitialEvent extends DatafetchEvent{}

class AddEvent extends DatafetchEvent{
  final double longitude,  latitude ;

  AddEvent({required this.longitude,required this.latitude});
}

class AllEvent extends DatafetchEvent{}
class DeleteEvent extends DatafetchEvent{
  final int id;

  DeleteEvent({required this.id});
}