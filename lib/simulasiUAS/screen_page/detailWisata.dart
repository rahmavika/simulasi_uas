import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/modelWisata.dart';
import 'maps.dart';

class PageDetail extends StatelessWidget {
  final Datum wisata;

  const PageDetail({super.key, required this.wisata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Wisata'),
        backgroundColor: Colors.grey[800],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wisata.gambar.isNotEmpty
                ? Image.network(
              'http://192.168.43.36/db_wisata/gambar/${wisata.gambar}',
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Icon(Icons.image_not_supported, size: 200, color: Colors.grey),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 20),
            Text(
              wisata.nama,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    wisata.lokasi,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(FontAwesomeIcons.infoCircle, color: Colors.blue),
                SizedBox(width: 5),
                Text(
                  'Deskripsi:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              wisata.deskripsi,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(FontAwesomeIcons.mapMarkerAlt, color: Colors.green),
                SizedBox(width: 5),
                Text(
                  'Koordinat:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Lat: ${wisata.lat}, Lng: ${wisata.lng}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(FontAwesomeIcons.map),
                label: Text('Lihat di Peta'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapsPage(
                        lat: double.parse(wisata.lat),
                        lng: double.parse(wisata.lng),
                        nama: wisata.nama,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
