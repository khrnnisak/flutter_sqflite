import 'package:flutter/material.dart';
import 'package:sqlite/Model/item.dart';

class EntryForm extends StatefulWidget {
  Item? item;

  EntryForm({Key? key, required this.item}) : super(key: key);

  @override
  State<EntryForm> createState() => EntryFormState(this.item);
}

class EntryFormState extends State<EntryForm> {
  Item? item;
  EntryFormState(this.item);

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (item != null) {
      nameController.text = item!.name;
      priceController.text = item!.price.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: item == null ? const Text('Tambah') : const Text('Ubah'),
        leading: Icon(Icons.keyboard_arrow_left),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Nama Barang
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  // TODO : method untuk form nama barang
                },
              ),
            ),

            // Harga Barang
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  // TODO : Method untuk form harga barang
                },
              ),
            ),

            // Tombol Button
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Row(
                children: [
                  // Tombol Simpan
                  Expanded(
                    child: ElevatedButton(
                      child: const Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        if (item == null) {
                          // Tambah Data
                          item = Item(nameController.text,
                              int.parse(priceController.text));
                        } else {
                          // Ubah Data
                          item!.name = nameController.text;
                          item!.price = int.parse(priceController.text);
                        }
                        // Kembali ke layar sebelumnya dengan membawa objek item
                        Navigator.pop(context, item);
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    // Tombol batal
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
