import 'package:flutter/material.dart';
import 'package:sqlite/Pages/entryform.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite/Helpers/sqlhelpers.dart';
import 'package:sqlite/Model/item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int count = 0;
  List<Item> itemList = [];
  SQLHelper sqlHelper = SQLHelper();

  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = <Item>[];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Item'),
      ),
      body: Column(
        children: [
          Expanded(
            child: createListView(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var item = await navigateToEntryForm(context, null);
                  if (item != null) {
                    //TODO 2 Panggil Fungsi untuk Insert ke DB
                    int result = await sqlHelper.createItem(item);
                    if (result > 0) {
                      updateListView();
                    }
                  }
                },
                child: const Text('Tambah Item'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item? item) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return EntryForm(item: item);
        },
      ),
    );
    return result;
  }

  ListView createListView() {
    TextStyle? textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => Card(
        color: Colors.white,
        elevation: 2.0,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.ad_units),
          ),
          title: Text(
            itemList[index].name,
            style: textStyle,
          ),
          subtitle: Text(itemList[index].price.toString()),
          trailing: GestureDetector(
            child: const Icon(Icons.delete),
            onTap: () async {
              // 3 TODO : Delete by id
              int result = await sqlHelper.deleteItem(itemList[index].id);
              if (result > 0) {
                updateListView();
              }
            },
          ),
          onTap: () async {
            // 4 TODO : Edit by id
            var item = await navigateToEntryForm(context, itemList[index]);
            if (item != null) {
              //TODO 5 : Update
              int result = await sqlHelper.updateItem(item);
              if (result > 0) {
                updateListView();
              }
            }
          },
        ),
      ),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = sqlHelper.db();
    dbFuture.then(
      (database) {
        // TODO : Get All Item From DB
        Future<List<Item>> itemListFuture = sqlHelper.getItemList();
        itemListFuture.then(
          (itemList) {
            setState(
              () {
                this.itemList = itemList;
                count = itemList.length;
              },
            );
          },
        );
      },
    );
  }
}
