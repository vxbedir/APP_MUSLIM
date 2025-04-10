import 'dart:math';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class QiblaService {
  // Kaaba coordinates
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;
  
  // Stream controller for Qibla direction
  final _qiblaStreamController = StreamController<double>.broadcast();
  Stream<double> get qiblaStream => _qiblaStreamController.stream;
  
  // Compass heading stream
  Stream<CompassEvent>? _compassStream;
  
  // Current position
  Position? _currentPosition;
  
  // Qibla direction in degrees
  double _qiblaDirection = 0.0;
  
  // Constructor
  QiblaService() {
    _init();
  }
  
  // Initialize the service
  Future<void> _init() async {
    try {
      // Get current position
      _currentPosition = await _getCurrentPosition();
      
      // Calculate Qibla direction
      _qiblaDirection = _calculateQiblaDirection(
        _currentPosition!.latitude, 
        _currentPosition!.longitude
      );
      
      // Start compass stream if available
      if (FlutterCompass.events != null) {
        _compassStream = FlutterCompass.events;
        _compassStream!.listen(_onCompassChanged);
      }
    } catch (e) {
      _qiblaStreamController.addError('Error initializing Qibla service: $e');
    }
  }
  
  // Handle compass changes
  void _onCompassChanged(CompassEvent event) {
    if (event.heading != null) {
      // Calculate the angle to Qibla by combining compass heading with Qibla direction
      final qiblaAngle = (event.heading! + _qiblaDirection) % 360;
      _qiblaStreamController.add(qiblaAngle);
    }
  }
  
  // Calculate Qibla direction using spherical trigonometry
  double _calculateQiblaDirection(double latitude, double longitude) {
    // Convert to radians
    final lat1 = _toRadians(latitude);
    final lon1 = _toRadians(longitude);
    final lat2 = _toRadians(kaabaLatitude);
    final lon2 = _toRadians(kaabaLongitude);
    
    // Calculate Qibla direction
    final y = sin(lon2 - lon1);
    final x = cos(lat1) * tan(lat2) - sin(lat1) * cos(lon2 - lon1);
    
    // Convert to degrees and normalize
    var qibla = _toDegrees(atan2(y, x));
    
    // Normalize to 0-360
    if (qibla < 0) {
      qibla += 360;
    }
    
    return qibla;
  }
  
  // Get current position
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }
    
    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    
    // Get current position
    return await Geolocator.getCurrentPosition();
  }
  
  // Update location
  Future<void> updateLocation() async {
    try {
      _currentPosition = await _getCurrentPosition();
      _qiblaDirection = _calculateQiblaDirection(
        _currentPosition!.latitude, 
        _currentPosition!.longitude
      );
    } catch (e) {
      _qiblaStreamController.addError('Error updating location: $e');
    }
  }
  
  // Convert degrees to radians
  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
  
  // Convert radians to degrees
  double _toDegrees(double radians) {
    return radians * 180 / pi;
  }
  
  // Dispose resources
  void dispose() {
    _qiblaStreamController.close();
  }
}
