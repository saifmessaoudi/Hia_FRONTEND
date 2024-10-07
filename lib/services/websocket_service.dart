import 'package:hia/services/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  IO.Socket? socket;
  final String marketId = '66f1cfbf43d0b72bb5359970'; 
  
  void connect() {
    socket = IO.io('http://192.168.101.145:3030', <String, dynamic>{
      'transports': ['websocket'],
      
      'autoConnect': true,
    });

    socket?.on('connect', (_) {
      print('Connected to WebSocket server');
      socket?.emit('joinMarketChannel', marketId);
    });

  socket?.on('newReservation', (reservation) async {
  print('New reservation received: $reservation');

  final Map<String, dynamic> reservationData = Map<String, dynamic>.from(reservation);

  final String codeReservation = reservationData['codeReservation'];
    

  await NotificationService().checkPermissions();
  
  await NotificationService().initNotification();
  await  NotificationService().showNotification(
    1,  // Notification ID
    'New Reservation : $codeReservation',  
    'Confirm reservation received',
  );
});


    socket?.on('disconnect', (_) {
      print('Disconnected from WebSocket server');
    });
socket?.on('connect_error', (error) {
  print('Connection Error: $error');
});

  }

  // Disconnect the socket connection
  void disconnect() {
    socket?.disconnect();
  }
}
