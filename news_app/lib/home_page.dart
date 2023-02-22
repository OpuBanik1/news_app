import 'package:flutter/material.dart';

import 'package:news_app/api/const.dart';
import 'package:news_app/news_model.dart';
import 'package:news_app/search.dart';
import 'package:page_transition/page_transition.dart';

import 'api/custom_http.dart';

// ignore: camel_case_types
class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  // String pageNo = '2';
  List<int> pageNo = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int currentIndex = 2;

  List<String> list = <String>['popularity', 'relevancy', 'publishedAt'];
  String sortBy = 'popularity';
  late CustomHttp customHttp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(
          'News App',
          style: myStyle(25, Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.topToBottom,
                    duration: Duration(seconds: 1),
                    child: Search(),
                  ),
                );
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    // margin: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
                    margin: EdgeInsets.fromLTRB(100, 5, 80, 5),
                    padding: EdgeInsets.all(5),
                    height: 50,
                    width: double.infinity,
                    color: Color(0xff03045E),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: pageNo.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Colors.white
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.all(12),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    currentIndex = index;
                                    // print("pppppppppp$currentIndex");
                                  });
                                },
                                child: Text('${pageNo[index]}')),
                          );
                        }),
                  ),
                  Positioned(
                    top: 8,
                    left: -10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      color: Colors.blueAccent,
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              currentIndex--;
                            });
                          },
                          child: Text(
                            'Previous',
                            style: myStyle(20, Colors.white),
                          )),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: -10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.blueAccent,
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              currentIndex++;
                            });
                          },
                          child: Text(
                            'Next',
                            style: myStyle(20, Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(8),
                  color: Colors.blue,
                  height: 60,
                  child: DropdownButton<String>(
                    value: sortBy,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurpleAccent),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        sortBy = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: myStyle(20, Colors.blueGrey),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              FutureBuilder<List<Articles>>(
                  future:
                      CustomHttp.fetchApi(page: currentIndex, sortBy: sortBy),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error 404');
                    } else if (snapshot.data == null) {
                      return Text("No data found");
                    }
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.network(
                                '${snapshot.data![index].urlToImage}'),
                            title: Text('${snapshot.data![index].title}'),
                            subtitle:
                                Text('${snapshot.data![index].description}'),
                          );
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
 // print('snapshot data is ${snapshot.data}');