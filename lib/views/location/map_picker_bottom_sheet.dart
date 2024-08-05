import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hia/constant.dart';
import 'package:hia/services/user_service.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/foodPreference/food_preferences_screen.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/widgets/custom_toast.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:latlong2/latlong.dart';

class MapPickerBottomSheet extends StatefulWidget {
  final Function(latLng.LatLng) onLocationPicked;
  
  final latLng.LatLng initialLocation;

  MapPickerBottomSheet({
    required this.onLocationPicked,
    required this.initialLocation,
  });

  @override
  _MapPickerBottomSheetState createState() => _MapPickerBottomSheetState();
}

class _MapPickerBottomSheetState extends State<MapPickerBottomSheet> {
  latLng.LatLng? pickedLocation;
  late MapController _mapController;
  bool showValidationButton = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    pickedLocation = widget.initialLocation;
     
  }

  @override
  Widget build(BuildContext context) {
          final userViewModel = Provider.of<UserViewModel>(context, listen: false);
final UserService userService = UserService();
    return Container(
      height: 400,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
               initialCenter: const LatLng(36.79250953369267, 10.190117943816045), 
          initialZoom: 11.0,
              onTap: (tapPosition, latLng) {
                setState(() {
                  pickedLocation = latLng;
                  showValidationButton = true;
                });
                widget.onLocationPicked(latLng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://api.mapbox.com/styles/v1/boogeyy/clyg8q8e500uv01qv8bb8bftb/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYm9vZ2V5eSIsImEiOiJjbHlnNmpoYmEwN3k1MmlwbzB0NHZvdXg4In0.puEqRDXeCxmqCQkCEOUEUg",
                additionalOptions: {
                  'accessToken': "pk.eyJ1IjoiYm9vZ2V5eSIsImEiOiJjbHlnNmpoYmEwN3k1MmlwbzB0NHZvdXg4In0.puEqRDXeCxmqCQkCEOUEUg",
                },
              ),
              MarkerLayer(
                markers: pickedLocation != null
                    ? [
                        Marker(
                          point: pickedLocation!,
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () async{
                             
                              
 
   
                       },
                       
                            child: SvgPicture.asset(
                              'images/map_marker.svg',
                              width: 40,
                              height: 40,
                            ),
                            
                          ),
                        ),
                      ]
                    : [],
              ),
            ],
          ),
          if (showValidationButton)
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () async {
                  // Handle validation button press
                  Position ?position = Position(
  latitude: pickedLocation!.latitude,
  longitude: pickedLocation!.longitude, // Updated Longitude for Hammam Chatt
  timestamp: DateTime.now(),
  accuracy: 1.0,
  altitude: 1.0,
  heading: 1.0,
  speed: 1.0,
  speedAccuracy: 1.0,
  altitudeAccuracy: 1.0,
  headingAccuracy: 1.0,
);
                  String? address = await userViewModel.getAddressFromCoordinates(
            position.latitude, position.longitude);

  userService.updateUserLocation(userViewModel.userId!, address!,
            position.longitude, position.latitude);
             const CustomToastWidget(
        isError: false,
        message: 'Location updated successfully',
      );
            Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FoodPreferencePage()),
      );

   ;
     
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: kMainColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
