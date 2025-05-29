import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';

final location = Location();

Future<LocationData> getUserLocation() async {
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) throw Exception('Location service disabled');
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted)
      throw Exception('Permission denied');
  }

  return await location.getLocation();
}

Offset gpsToOffset(
  double userLat,
  double userLon,
  double lat1,
  double lon1,
  double lat2,
  double lon2,
  double imageWidth,
  double imageHeight,
) {
  final dx = (userLon - lon1) / (lon2 - lon1) * imageWidth;
  final dy = (1 - (userLat - lat2) / (lat1 - lat2)) * imageHeight;
  return Offset(dx, dy);
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String mapAssetPath = 'assets/my_map.png';
  final double mapWidth = 761;
  final double mapHeight = 951;

  final double topLeftLat = 52.467758854893845;
  final double topLeftLon = 16.928450880513054;
  final double bottomRightLat = 52.46528829827169;
  final double bottomRightLon = 16.931344155155415;

  Timer? _locationTimer;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    // Get initial location
    getUserLocation().then((location) {
      setState(() {
        _currentLocation = location;
      });
    });

    // Set up periodic updates
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      getUserLocation().then((location) {
        setState(() {
          _currentLocation = location;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scale = screenSize.width / mapWidth;
    final scaledHeight = mapHeight * scale;

    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final userOffset = gpsToOffset(
      _currentLocation!.latitude!,
      _currentLocation!.longitude!,
      topLeftLat,
      topLeftLon,
      bottomRightLat,
      bottomRightLon,
      mapWidth,
      mapHeight,
    );

    return Center(
      child: SizedBox(
        width: screenSize.width,
        height: scaledHeight,
        child: Stack(
          children: [
            Image.asset(mapAssetPath, fit: BoxFit.fill),
            Positioned(
              left: userOffset.dx * scale,
              top: userOffset.dy * scale,
              child: const Icon(Icons.location_on, color: Colors.red, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
