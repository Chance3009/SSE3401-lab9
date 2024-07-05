import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab9/api/my_api.dart';
import 'package:lab9/components/text_widget.dart';
import 'package:lab9/models/get_article_info.dart';
import 'package:lab9/pages/detail_book.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  var articles = <ArticleInfo>[];
  var allarticles = <ArticleInfo>[];

  @override
  void initState() {
    _getArticles();
    super.initState();
  }

  _getArticles() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");

/*
    if(user!=null){
    var userInfo=jsonDecode(user);
      debugPrint(userInfo);
    }else{
      debugPrint("no info");
    }*/
    await _initData();
  }

  _initData() async {
    await CallApi().getPublicData("recommendedarticles").then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        articles = list.map((model) => ArticleInfo.fromJson(model)).toList();
      });
    });
    await CallApi().getPublicData("allarticles").then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        allarticles = list.map((model) => ArticleInfo.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    debugPrint(height.toString());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: const Color(0xFFffffff),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 30),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.menu_book_sharp, color: Color(0xFF363f93)),
                Icon(Icons.menu, color: Color(0xFF363f93)),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                TextWidget(text: "Today", fontSize: 36),
                Expanded(child: Container()),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          Container(
            height: 80,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SearchBar(),
            ),
          ),
          SizedBox(height: height * 0.02),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(text: "Recommend", fontSize: 30),
                Expanded(child: Container()),
                Row(
                  children: [
                    TextWidget(
                      text: "view all",
                      fontSize: 16,
                      color: const Color(0xFFa9b3bd),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF363f93),
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          Container(
            height: height * 0.27,
            child: PageView.builder(
              controller: PageController(viewportFraction: .9),
              itemCount: articles.length,
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: () {
                    debugPrint(i.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailBookPage(
                                articleInfo: articles[i], index: i)));
                  },
                  child: articles.length == 0
                      ? const CircularProgressIndicator()
                      : Stack(
                          children: [
                            Positioned(
                              top: 35,
                              child: Material(
                                elevation: 0.0,
                                child: Container(
                                  height: 180.0,
                                  width: width * 0.85,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          offset: Offset(-10.0, 0.0),
                                          blurRadius: 20.0,
                                          spreadRadius: 4.0,
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 10,
                              child: Card(
                                elevation: 10.0,
                                shadowColor: Colors.grey.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  height: 200,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          "http://10.0.2.2:8000/uploads/" +
                                              articles[i].img),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 45,
                              left: width * 0.4,
                              child: Container(
                                height: 200,
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                        text: articles[i].title, fontSize: 20),
                                    TextWidget(
                                        color: Colors.grey,
                                        text: articles[i].author,
                                        fontSize: 16),
                                    const Divider(color: Colors.black),
                                    TextWidget(
                                        color: Colors.grey,
                                        text: articles[i].description,
                                        fontSize: 16)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 30),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: "New Book List",
                    fontSize: 30,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: "view all",
                        fontSize: 16,
                        color: const Color(0xFFa9b3bd),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF363f93),
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: height * 0.4,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allarticles.length,
                    itemBuilder: (_, i) {
                      debugPrint(allarticles[i].img.toString());
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailBookPage(
                                        articleInfo: allarticles[i], index: i)));
                          },
                          child: allarticles.length == 0
                              ? CircularProgressIndicator()
                              : Container(
                                  height: height * 0.4,
                                  width: 150,
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Card(
                                        semanticContainer: true,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Image.network(
                                          "http://10.0.2.2:8000/uploads/" +
                                              allarticles[i].img.toString(),
                                          fit: BoxFit.contain,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 5,
                                      ),
                                      TextWidget(
                                          text: allarticles[i].title,
                                          fontSize: 20),
                                      TextWidget(
                                        text: allarticles[i].author,
                                        fontSize: 16,
                                        color: Color(0xFFa9b3bd),
                                      ),
                                    ],
                                  ),
                                ));
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
