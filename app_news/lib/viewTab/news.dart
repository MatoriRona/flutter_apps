import 'dart:convert';
import 'package:app_news/constant/constantsFile.dart';
import 'package:app_news/constant/newsModel.dart';
import 'package:app_news/viewTab/editNews.dart';
import 'package:app_news/viewTabs/addNews.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final List<NewsModel> list = [];
  var loading = false;

  Future<void> _lihatData() async {
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(BaseUrl.detailNews));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      list.clear();
      data.forEach((api) {
        final ab = NewsModel(
          api['id_news'],
          api['image'],
          api['title'],
          api['content'],
          api['description'],
          api['date_news'],
          api['id_user'],
          api['username'],
        );
        list.add(ab);
      });
    }

    setState(() {
      loading = false;
    });
  }

  _delete(String id_news) async {
    final response =
        await http.post(BaseUrl.deleteNews as Uri, body: {"id_news": id_news});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      _lihatData();
    } else {
      print(pesan);
    }
  }

  dialogDelete(String id_news) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListView(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            children: [
              Text(
                'Apakah Data ini dihapus?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10), // Tambahkan jarak antara tombol
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Tutup dialog
                    },
                    child: Text('No'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _delete(id_news);
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNews()));
        },
        child: Icon(Icons.add),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.network(
                            BaseUrl.addNews + x.image,
                            width: 150,
                            height: 120,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                x.title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(x.date_news),
                            ],
                          )),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) =>
                                        EditNews(x, _lihatData))));
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                dialogDelete(x.id_news);
                              },
                              icon: Icon(Icons.delete)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
