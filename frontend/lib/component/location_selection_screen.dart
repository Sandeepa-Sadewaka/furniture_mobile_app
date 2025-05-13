
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
class LocationSelectionScreen extends StatefulWidget {
  final Function(LatLng, String?) onLocationSelected;

  const LocationSelectionScreen({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(7.8731, 80.7718); // Default to Sri Lanka
  LatLng? _selectedLocation;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    _initialPosition = LatLng(position.latitude, position.longitude);

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_initialPosition));
    }

    setState(() {});
  }

  Future<void> _getAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        _selectedAddress = "${place.street}, ${place.locality}, ${place.country}";
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Delivery Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_selectedLocation != null) {
                widget.onLocationSelected(_selectedLocation!, _selectedAddress);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a location')));
              }
            },
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14),
        onMapCreated: (controller) => _mapController = controller,
        myLocationEnabled: true,
        onTap: (LatLng pos) async {
          _selectedLocation = pos;
          await _getAddress(pos);
          setState(() {});
        },
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: const MarkerId('selected-location'),
                  position: _selectedLocation!,
                  infoWindow: InfoWindow(title: 'Delivery Location', snippet: _selectedAddress),
                )
              }
            : {},
      ),
    );
  }
}