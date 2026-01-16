import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // 🔥 PENTING
  final String baseUrl = "http://localhost/api_pacar";

  late Future<List<Map<String, String>>> futurePacar;

  final TextEditingController nama = TextEditingController();
  final TextEditingController umur = TextEditingController();
  final TextEditingController hobi = TextEditingController();

  @override
  void initState() {
    super.initState();
    futurePacar = getPacar();
  }

  // ================= API =================

  Future<List<Map<String, String>>> getPacar() async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_pacar.php"),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // 🔥 PAKSA SEMUA JADI STRING (ANTI ERROR FLUTTER WEB)
      return data.map<Map<String, String>>((item) {
        return {
          "id": item["id"].toString(),
          "nama": item["nama"].toString(),
          "umur": item["umur"].toString(),
          "hobi": item["hobi"].toString(),
        };
      }).toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future<void> insertPacar() async {
    await http.post(
      Uri.parse("$baseUrl/add_update_pacar.php"),
      body: {
        "nama": nama.text,
        "umur": umur.text,
        "hobi": hobi.text,
      },
    );

    nama.clear();
    umur.clear();
    hobi.clear();

    setState(() {
      futurePacar = getPacar();
    });
  }

  Future<void> deletePacar(String id) async {
    await http.post(
      Uri.parse("$baseUrl/delete_pacar.php"),
      body: {"id": id},
    );

    setState(() {
      futurePacar = getPacar();
    });
  }

  // ================= UI =================

  void dialogTambah() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Pacar"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nama,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: umur,
              decoration: const InputDecoration(labelText: "Umur"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: hobi,
              decoration: const InputDecoration(labelText: "Hobi"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              insertPacar();
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pacar ❤️"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: dialogTambah,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: futurePacar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada data pacar 😅"),
            );
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              return Card(
                child: ListTile(
                  title: Text(data[i]['nama']!),
                  subtitle: Text(
                    "Umur: ${data[i]['umur']} | Hobi: ${data[i]['hobi']}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deletePacar(data[i]['id']!);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}