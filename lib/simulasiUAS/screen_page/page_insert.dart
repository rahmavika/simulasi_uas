import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/modelInsert.dart';

class PageInsert extends StatefulWidget {
  final VoidCallback refreshData;

  const PageInsert({super.key, required this.refreshData});

  @override
  State<PageInsert> createState() => _PageInsertState();
}

class _PageInsertState extends State<PageInsert> {
  TextEditingController txtNama = TextEditingController();
  TextEditingController txtLokasi = TextEditingController();
  TextEditingController txtDeskripsi = TextEditingController();
  TextEditingController txtLat = TextEditingController();
  TextEditingController txtLng = TextEditingController();
  TextEditingController txtProfil = TextEditingController();
  TextEditingController txtGambar = TextEditingController();

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> addWisata() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response response = await http.post(
        Uri.parse('http://192.168.43.36/db_wisata/simpanWisata.php'),
        body: {
          "nama": txtNama.text,
          "lokasi": txtLokasi.text,
          "deskripsi": txtDeskripsi.text,
          "lat": txtLat.text,
          "lng": txtLng.text,
          "profil": txtProfil.text,
          "gambar": txtGambar.text,
        },
      );

      if (response.statusCode == 200) {
        ModelInsert data = modelInsertFromJson(response.body);
        if (data.value == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data.message)),
          );
          widget.refreshData();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data.message)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Wisata'),
        backgroundColor: Colors.grey[800],
      ),
      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextField('Nama', txtNama),
                buildTextField('Lokasi', txtLokasi),
                buildTextField('Deskripsi', txtDeskripsi),
                buildTextField('Lat', txtLat),
                buildTextField('Lng', txtLng),
                buildTextField('Profil', txtProfil),
                buildTextField('Gambar', txtGambar),
                SizedBox(height: 20),
                Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : MaterialButton(
                    minWidth: 150,
                    height: 45,
                    onPressed: () {
                      if (keyForm.currentState?.validate() == true) {
                        addWisata();
                      }
                    },
                    child: Text('Insert'),
                    color: Colors.grey[800],
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: (val) => val!.isEmpty ? "Tidak boleh kosong" : null,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PageInsert(refreshData: () {}),
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
