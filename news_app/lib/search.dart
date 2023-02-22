import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/custom_http.dart';
import 'package:news_app/news_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search_controller = TextEditingController();
  List<Articles> search_data = [];

  List<String> searchList = [
    'Education',
    'Weather',
    'Entertainment',
    'Sports',
    'Movie',
    'crypto',
    'Fashion'
  ];

  FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    search_controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool isLoading = false;
  //
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      blur: 0.5,
      opacity: 0.5,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    height: 60,
                    child: TextField(
                      focusNode: focusNode,
                      controller: search_controller,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () async {
                                search_data = await CustomHttp.searchApi(
                                    search: search_controller.text);
                                print('$search_data');
                                setState(() {});
                              },
                              icon: Icon(Icons.search)),
                          labelText: 'Search ..',
                          hintText: 'Search here..',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: MasonryGridView.count(
                      crossAxisCount: 4,
                      itemCount: searchList.length,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async {
                              search_controller.text = searchList[index];
                              setState(() {
                                isLoading = true;
                              });
                              search_data = await CustomHttp.searchApi(
                                  search: searchList[index]);
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Text('${searchList[index]}'));
                      },
                    ),
                  ),
                  search_data.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: search_data.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Image.network(
                                  '${search_data[index].urlToImage}'),
                              title: Text('${search_data[index].title}'),
                              subtitle:
                                  Text('${search_data[index].description}'),
                            );
                          })
                      : SizedBox(
                          child: Text('No data found'),
                          height: 15,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
