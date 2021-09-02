import 'package:flutter/material.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';

class modifierpage extends StatefulWidget {
  List<File> image;
  // get image => image;
  modifierpage(List<File> image) {
    this.image = image;
  }

  @override
  _modifierpageState createState() => _modifierpageState();
}
// final key = new GlobalKey<MyStatefulWidget1State>();

class _modifierpageState extends State<modifierpage> {
  int currentindex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modify Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteCurrentPage,
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                height: 600.0,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentindex = index;
                    print(currentindex);
                  });
                },
              ),
              items: widget.image.map((i) {
                // currentindex = widget.image.indexOf(i);
                // print(currentindex);
                return Builder(
                  builder: (BuildContext context) {
                    return Card(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      elevation: 10,
                      margin: EdgeInsets.all(10),
                      child: Container(
                          height: 550,
                          // margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.amber),
                          child: Image.file(
                            i,
                            fit: BoxFit.cover,
                          )),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  deleteCurrentPage() {
    setState(() {
      widget.image.removeAt(currentindex);
    });
  }
}
// changePageNo(int page){

// }
