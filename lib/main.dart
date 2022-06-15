import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googlemapdemo/database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController googleMapController;
  Position? position;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    myLocation();
  }

  myLocation() async {
    position = await _getPosition();
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                position?.latitude as double, position?.longitude as double),
            zoom: 14)));
    markers.clear();

    markers.add(Marker(
        markerId: const MarkerId("currentLocation"),
        position: LatLng(
            position?.latitude as double, position?.longitude as double)));

    setState(() {});
  }

  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error("Please unable location permission");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Please unable location permission");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Please unable location permission");
    }
    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition:
              const CameraPosition(target: LatLng(10.7, -122.4), zoom: 12),
          markers: markers,
          mapType: MapType.satellite,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          }),
      floatingActionButton: FloatingActionButton(
        child: const Text("Save Location"),
        onPressed: () async {
          await DatabaseHelper.instance.add(LocationData(
              latitude: position?.latitude as double,
              longitude: position?.longitude as double));
        },
      ),
    );
  }
}
