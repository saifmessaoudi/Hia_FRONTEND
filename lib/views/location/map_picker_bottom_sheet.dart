import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerBottomSheet extends StatefulWidget {
  final Function(LatLng) onLocationPicked;

  MapPickerBottomSheet({required this.onLocationPicked});

  @override
  _MapPickerBottomSheetState createState() => _MapPickerBottomSheetState();
}

class _MapPickerBottomSheetState extends State<MapPickerBottomSheet> {
  LatLng? pickedLocation;
  GoogleMapController? mapController;
  Set<TileOverlay> tileOverlays = Set();

  @override
  void initState() {
    super.initState();
    _addTileOverlay();
  }

  void _addTileOverlay() {
    setState(() {
      tileOverlays.add(TileOverlay(
        tileOverlayId: TileOverlayId('custom_tile_overlay'),
        tileProvider: CustomTileProvider(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default to San Francisco
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onTap: (LatLng position) {
          setState(() {
            pickedLocation = position;
          });
          widget.onLocationPicked(position);
        },
        markers: pickedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('picked_location'),
                  position: pickedLocation!,
                ),
              }
            : {},
        tileOverlays: tileOverlays,
      ),
    );
  }
}

class CustomTileProvider implements TileProvider {
  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    // Custom tile provider logic
    // Return a transparent tile for demonstration purposes
    return Tile(256, 256, null);
  }
}
