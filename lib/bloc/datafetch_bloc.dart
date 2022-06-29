import 'package:bloc/bloc.dart';
import '../database.dart';

part 'datafetch_event.dart';

part 'datafetch_state.dart';

class DatafetchBloc extends Bloc<DatafetchEvent, DatafetchState> {
  DatafetchBloc() : super(DatafetchInitial()) {
    on<AddEvent>(_onAddLocation);
    on<DeleteEvent>(_onDeleteLocation);
    on<AllEvent>(_onAllLocation);
  }

  void _onAddLocation(AddEvent event, Emitter<DatafetchState> emit) async {
    await DatabaseHelper.instance.add(
        LocationData(latitude: event.latitude, longitude: event.longitude));
    emit(DatafetchLoaded(
        data: await DatabaseHelper.instance.getData()));
  }
  void _onDeleteLocation(DeleteEvent event, Emitter<DatafetchState> emit) async {
    DatabaseHelper.instance.delete(event.id);
    emit(DatafetchLoaded(
        data: await DatabaseHelper.instance.getData() ));
  }

  void _onAllLocation(AllEvent event, Emitter<DatafetchState> emit) async {
    emit(DatafetchLoaded(
        data: await DatabaseHelper.instance.getData() ));
  }
}
