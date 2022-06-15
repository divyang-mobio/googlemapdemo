import 'package:flutter/material.dart';

import 'database.dart';

class LocationList extends StatefulWidget {
  const LocationList({Key? key}) : super(key: key);

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: FutureBuilder<List<LocationData>>(
          future: DatabaseHelper.instance.getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        DatabaseHelper.instance
                            .delete(snapshot.data?[index].id as int);
                      });

                    },
                    child: Card(
                      elevation: 8,
                        child: Column(
                      children: [
                        ListTile(
                          title: Text(
                              "id: ${snapshot.data?[index].id.toString()}"),
                        ),
                        ListTile(
                          title: Text(
                              "longitude: ${snapshot.data?[index].longitude.toString()}"),
                        ),
                        ListTile(
                          title: Text(
                              "latitude: ${snapshot.data?[index].latitude.toString()}"),
                        ),
                      ],
                    )),
                  );
                });
          }),
    );
  }
}
