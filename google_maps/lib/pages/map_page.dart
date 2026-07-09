import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';



class MapPage extends StatefulWidget{
	const MapPage ({super.key});

	@override
	State<MapPage> createState() => _MapState();
}

class _MapState extends State<MapPage>{
	
 	LatLng? sourceLocation = null;

	LatLng? _currentPos = null;
	Position? _currentUserLocation;

	@override
	void initState(){
		print("initState called -------------------");
		super.initState();
		getLocationUpdates();

	}

	@override
	Widget build(BuildContext context){
		return Scaffold(
			body: GoogleMap(
				initialCameraPosition: CameraPosition(
					target: sourceLocation!, 
					zoom: 10,
				),
				markers: {
				Marker(
					markerId: MarkerId("_currentLocation"),
					icon: BitmapDescriptor.defaultMarker,
					position: sourceLocation!,
				),
			},
			),
		);
	}


	Future<void> getLocationUpdates() async {
		// checks if location access has been enabled
		bool _serviceEnabled;
		//the permission
		LocationPermission locationPermission;
		Position locationData;

		_serviceEnabled = await Geolocator.isLocationServiceEnabled();
		if(!_serviceEnabled){
			return Future.error('Location service are disabled');
		}

		locationPermission = await Geolocator.checkPermission();
		if (locationPermission == LocationPermission.denied) {
			locationPermission = await Geolocator.requestPermission();
			if(locationPermission == LocationPermission.denied){
				return Future.error("Location permission denied");
			}

		  }

		if(locationPermission == LocationPermission.deniedForever){
			return Future.error(
			'Location permissions are permanarly denied, weconn'
		);
	}
		final LocationSettings locationSettings = LocationSettings(
		accuracy: LocationAccuracy.high,
		distanceFilter: 100,
	);

		locationData = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
		print('location data----------------->');
		print(locationData);

		var accuracy = await Geolocator.getLocationAccuracy();
		print('location data----------------->');
		print(accuracy);


		StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
		(Position? position) {
				print(position == null ? 'Unknown' : '${locationData.latitude.toString()}, ${locationData.longitude.toString()}');
			});



		// get notification on location changes,
		// get the location changes
		setState(() {
			sourceLocation = LatLng(
				locationData.latitude,
				locationData.longitude,
			);
		});

	}
}
