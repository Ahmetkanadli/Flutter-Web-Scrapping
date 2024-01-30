import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:web_scrapping/kitap.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var url = Uri.parse(
      "https://www.kitapyurdu.com/index.php?route=product/category&filter_category_all=true&path=1_737&sort=publish_date&order=DESC");
  var data;

  List<Kitap> kitaplar = [];

  Future getData() async {
    var res = await http.get(url);
    final body = res.body;
    final document = parser.parse(body);
    var response = document.
    getElementsByClassName("product-grid")[0].
    getElementsByClassName("product-cr").forEach((element) {
      setState(() {
        kitaplar.add(
            Kitap(
              image: element.children[2].children[0].children[0].children[0].attributes['src'].toString(),
              kitapAdi: element.children[3].text.toString(),
              yayinEvi: element.children[4].text.toString(),
              fiyat: element.children[8].children[0].text.toString(),
            )
        );
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Scrapping"),
      ),
      body: SafeArea(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: kitaplar.length,
              itemBuilder: (context, index) =>
                  Card(
                    elevation: 6,
                    color: Colors.blueGrey,
                    child: Column(
                      children: [
                        ClipRect(

                          child: Image.network(
                           kitaplar[index].image,
                            fit:BoxFit.fill,),
                        ),
                        Text("Kitap ismi : ${kitaplar[index].kitapAdi}"),
                        Text("Kitap yayın evi : ${kitaplar[index].yayinEvi}"),
                        Text("Kitap fiyatı : ${kitaplar[index].fiyat}"),
                      ],
                    ),
                  )
          )
      ),
    );
  }
}
