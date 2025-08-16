import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseInitializer {
  static Future<void> initializeDatabase() async {
    final firestore = FirebaseFirestore.instance;

    // Check if data already exists
    final cinemasSnapshot = await firestore
        .collection('cinemas')
        .limit(1)
        .get();
    if (cinemasSnapshot.docs.isNotEmpty) {
      print('Database already initialized');
      return;
    }

    try {
      // Load JSON from assets
      String jsonString = await rootBundle.loadString(
        'assets/sample_data/sample_data.json',
      );
      Map<String, dynamic> data = json.decode(jsonString);

      // Import cinemas
      await _importCinemas(firestore, data['cinemas']);

      // Import theaters (subcollections)
      await _importTheaters(firestore, data['theaters']);

      // Import movies
      await _importMovies(firestore, data['movies']);

      // Import showtimes
      await _importShowtimes(firestore, data['showtimes']);

      // Import counters
      await _importCounters(firestore, data['counters']);

      print('Database initialized successfully!');
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  static Future<void> _importCinemas(
    FirebaseFirestore firestore,
    List<dynamic> cinemas,
  ) async {
    final batch = firestore.batch();

    for (var cinema in cinemas) {
      final docRef = firestore.collection('cinemas').doc(cinema['id']);

      // Convert location to GeoPoint
      final locationData = cinema['location'];
      final geoPoint = GeoPoint(
        locationData['_latitude'],
        locationData['_longitude'],
      );

      final cinemaData = Map<String, dynamic>.from(cinema);
      cinemaData['location'] = geoPoint;
      cinemaData['createdAt'] = Timestamp.fromDate(
        DateTime.parse(cinema['createdAt']),
      );
      cinemaData['updatedAt'] = Timestamp.fromDate(
        DateTime.parse(cinema['updatedAt']),
      );

      batch.set(docRef, cinemaData);
    }

    await batch.commit();
    print('Imported ${cinemas.length} cinemas');
  }

  static Future<void> _importTheaters(
    FirebaseFirestore firestore,
    Map<String, dynamic> theatersByCinema,
  ) async {
    for (var cinemaId in theatersByCinema.keys) {
      final theaters = theatersByCinema[cinemaId] as List<dynamic>;
      final batch = firestore.batch();

      for (var theater in theaters) {
        final docRef = firestore
            .collection('cinemas')
            .doc(cinemaId)
            .collection('theaters')
            .doc(theater['id']);

        batch.set(docRef, theater);
      }

      await batch.commit();
      print('Imported ${theaters.length} theaters for cinema $cinemaId');
    }
  }

  static Future<void> _importMovies(
    FirebaseFirestore firestore,
    List<dynamic> movies,
  ) async {
    final batch = firestore.batch();

    for (var movie in movies) {
      final docRef = firestore.collection('movies').doc(movie['id']);

      final movieData = Map<String, dynamic>.from(movie);
      movieData['createdAt'] = Timestamp.fromDate(
        DateTime.parse(movie['createdAt']),
      );
      movieData['updatedAt'] = Timestamp.fromDate(
        DateTime.parse(movie['updatedAt']),
      );

      batch.set(docRef, movieData);
    }

    await batch.commit();
    print('Imported ${movies.length} movies');
  }

  static Future<void> _importShowtimes(
    FirebaseFirestore firestore,
    List<dynamic> showtimes,
  ) async {
    final batch = firestore.batch();

    for (var showtime in showtimes) {
      final docRef = firestore.collection('showtimes').doc(showtime['id']);

      final showtimeData = Map<String, dynamic>.from(showtime);
      showtimeData['startDateTime'] = Timestamp.fromDate(
        DateTime.parse(showtime['startDateTime']),
      );
      showtimeData['endDateTime'] = Timestamp.fromDate(
        DateTime.parse(showtime['endDateTime']),
      );
      showtimeData['createdAt'] = Timestamp.fromDate(
        DateTime.parse(showtime['createdAt']),
      );
      showtimeData['updatedAt'] = Timestamp.fromDate(
        DateTime.parse(showtime['updatedAt']),
      );

      batch.set(docRef, showtimeData);
    }

    await batch.commit();
    print('Imported ${showtimes.length} showtimes');
  }

  static Future<void> _importCounters(
    FirebaseFirestore firestore,
    List<dynamic> counters,
  ) async {
    final batch = firestore.batch();

    for (var counter in counters) {
      final docRef = firestore.collection('counters').doc(counter['id']);

      final counterData = Map<String, dynamic>.from(counter);
      counterData['lastUpdated'] = Timestamp.fromDate(
        DateTime.parse(counter['lastUpdated']),
      );

      batch.set(docRef, counterData);
    }

    await batch.commit();
    print('Imported ${counters.length} counters');
  }
}
