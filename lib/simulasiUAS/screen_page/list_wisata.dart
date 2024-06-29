import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simulasi_uas/simulasiUAS/screen_page/update.dart';
import 'dart:convert';
import '../model/modelWisata.dart';
import 'detailWisata.dart';
import 'page_insert.dart';

class PageWisata extends StatefulWidget {
  const PageWisata({super.key});

  @override
  State<PageWisata> createState() => _PageWisataState();
}

class _PageWisataState extends State<PageWisata> {
  bool isLoading = true;
  List<Datum> wisataList = [];

  @override
  void initState() {
    super.initState();
    fetchWisata();
  }

  Future<void> fetchWisata() async {
    final response = await http.get(Uri.parse('http://192.168.43.36/db_wisata/getWisata.php'));

    if (response.statusCode == 200) {
      final data = modelWisataFromJson(response.body);
      setState(() {
        wisataList = data.data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data')),
      );
    }
  }

  void refreshData() {
    setState(() {
      isLoading = true;
    });
    fetchWisata();
  }

  Future<void> deleteWisata(String id) async {
    final response = await http.post(
      Uri.parse('http://192.168.43.36/db_wisata/deleteWisata.php'),
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['value'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonData['message'])),
        );
        refreshData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonData['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Wisata'),
        backgroundColor: Colors.grey[800],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: wisataList.length,
        itemBuilder: (context, index) {
          final wisata = wisataList[index];
          return Card(
            color: Colors.grey[100],
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: wisata.gambar.isNotEmpty
                        ? Image.network(
                      'http://192.168.43.36/db_wisata/gambar/${wisata.gambar}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                  title: Text(
                    wisata.nama,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  subtitle: Text(
                    wisata.lokasi,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageDetail(wisata: wisata),
                      ),
                    );
                  },
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueGrey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageUpdate(
                              wisata: wisata,
                              refreshData: refreshData,
                            ),
                          ),
                        ).then((value) => fetchWisata());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        deleteWisata(wisata.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PageInsert(refreshData: refreshData),
            ),
          );
          refreshData();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PageWisata(),
    theme: ThemeData(
      primarySwatch: Colors.grey,
      hintColor: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.grey[200],
      appBarTheme: AppBarTheme(
        color: Colors.grey[800],
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey[800],
      ),
    ),
  ));
}
