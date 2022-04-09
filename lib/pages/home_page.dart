import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:pattern_setstate/services/http_service.dart';

import '../post_model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = "home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];

  void _apiPostList() async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    setState(() {
      if (response != null) {
        items = Network.parsePostList(response).cast<Post>();
      } else {
        items = [];
      }
      isLoading = false;
    });
  }

  void _apiPostDelete(Post post) async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.DEL(Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    setState(() {
      if (response != null) {
        _apiPostList();
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pattern - setState"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return itemOfPost(items[index]);
            },
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  Widget itemOfPost(Post post) {
    return Slidable(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title!.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(post.body!),
          ],
        ),
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            label: 'Update',
            backgroundColor: Colors.indigo,
            icon: Icons.edit,
            onPressed: (context) {},
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (context) {
              _apiPostDelete(post);
            },
          ),
        ],
      ),
    );
  }

}
