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

	final LatLng kakamega = LatLng(0.2827, 34.7519);
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
					target: kakamega, 
					zoom: 15,
				),
				markers: {
				Marker(
					markerId: const MarkerId("me"),
					position: sourceLocation!,
					icon: BitmapDescriptor.defaultMarkerWithHue(
					BitmapDescriptor.hueBlue,
					),
				),
				Marker(
					markerId: MarkerId("location to show"),
					icon: BitmapDescriptor.defaultMarker,
					position: kakamega,
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
		// location settings
		final LocationSettings locationSettings = LocationSettings(
			accuracy: LocationAccuracy.best,
			distanceFilter: 5,
			timeLimit: Duration(seconds: 5),
		);

		try{

		locationData = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
		print('location data----------------->');
		print(locationData);

		var accuracy = await Geolocator.getLocationAccuracy();
		print('location accuracy----------------->');
		print(accuracy);


		StreamSubscription<Position> positionStream =
		Geolocator.getPositionStream(locationSettings: locationSettings).listen(
		(Position? position) {	print('this is the position of the location currently ------------------------------->');
				if (position != null) {
      				print('Current location: ${position.latitude}, ${position.longitude}');
				} else {
     					 print('Unknown location');
    					}
				},
		);



		// get notification on location changes,
		// get the location changes
		setState(() {
			sourceLocation = LatLng(
				locationData.latitude,
				locationData.longitude,
			);
		});
		} catch(e) {
			print('error gettting location: $e');
		}

	}
}
