import 'package:latlong2/latlong.dart';
class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location; // Use LatLng from latlong2
  final int? rating;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  });
}

final mapMarkers = [
  MapMarker(
      image: 'images/restaurant_1.jpg',
      title: 'Alexander The Great Restaurant',
      address: 'P8Q4+P4X, Ez Zahra',
      location: LatLng(36.74013, 10.30364),
      rating: 8),
  MapMarker(
      image: 'images/restaurant_2.jpg',
      title: 'Mestizo Mexican Restaurant',
      address: '103 Hampstead Rd, London NW1 3EL, United Kingdom',
      location: LatLng(51.5090229, -0.2886548),
      rating: 5),
  MapMarker(
      image: 'images/restaurant_3.jpg',
      title: 'The Shed',
      address: '122 Palace Gardens Terrace, London W8 4RT, United Kingdom',
      location: LatLng(51.5090215, -0.1959988),
      rating: 2),
  MapMarker(
      image: 'images/restaurant_4.jpg',
      title: 'Gaucho Tower Bridge',
      address: '2 More London Riverside, London SE1 2AP, United Kingdom',
      location: LatLng(51.5054563, -0.0798412),
      rating: 3),
  MapMarker(
    image: 'images/restaurant_5.jpg',
    title: 'Bill\'s Holborn Restaurant',
    address: '42 Kingsway, London WC2B 6EY, United Kingdom',
    location: LatLng(51.5077676, -0.2208447),
    rating: 4,
  ),
];
