import 'package:google_geocoding/google_geocoding.dart' hide LatLon;
import 'package:google_place/google_place.dart' hide LatLon;
import 'package:hey/model/latlon.dart';
import 'package:hey/util/log.dart';

class LocationService with Log {
  final GooglePlace _place;
  final GoogleGeocoding _geocoding;

  LocationService(String key)
      : _place = GooglePlace(key),
        _geocoding = GoogleGeocoding(key);

  Future<LatLon> fetchLocation(String query) async {
    final geocode = await _geocoding.geocoding.get(query, const []);

    if (geocode?.status != "OK") {
      switch (geocode?.status) {
        case null:
          log.wtf("Null response from geocode service");
          throw Exception("Null response from geocode");
        case "ZERO_RESULTS":
          log.i("Zero results for address $query");
          throw 0;
        case "UNKNOWN_ERROR":
          log.wtf("Unknown error when geocoding");
          throw Exception("Geocode error");
        case "REQUEST_DENIED":
        case "INVALID_REQUEST":
        default:
          log.e(geocode!.status);
          throw Exception("Geocode status ${geocode.status}");
      }
    }

    final latLon = LatLon(geocode?.results?[0].geometry?.location?.lat ?? 0,
        geocode?.results?[0].geometry?.location?.lng ?? 0);

    if (latLon.lat == 0 || latLon.lon == 0) {
      log.wtf("Error fetching location");
      throw Exception("Location (0,0)");
    }

    return latLon;
  }
}
