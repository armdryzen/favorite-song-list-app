// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_booklist/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Favorite Song List App',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          scaffoldBackgroundColor: Color.fromARGB(248, 143, 143, 143)),
      home: const MyHomePage(title: 'Favorite Song List App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    refreshSongs();
    super.initState();
  }

  // Collect Data from DB
  List<Map<String, dynamic>> songs = [];
  void refreshSongs() async {
    final data = await SQLHelper.getSongs();
    setState(() {
      songs = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(songs);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) => Card(
                color: Color.fromARGB(155, 255, 193, 7),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  isThreeLine: true,
                  title: Text(songs[index]['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Color.fromARGB(255, 0, 0, 0))),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Artist  : " + songs[index]['artist'],
                          style: TextStyle(
                              height: 1.4,
                              fontSize: 15,
                              color: Color.fromARGB(255, 0, 0, 0))),
                      Text("Year    : " + songs[index]['year'],
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 0, 0, 0))),
                      Text(
                        "Genre  : " + songs[index]['genre'],
                        style: TextStyle(
                            height: 1.4, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 109,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => deleteSong(songs[index]['id']),
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 70, 67, 67),
                            )),
                        IconButton(
                            onPressed: () => modalForm(songs[index]['id']),
                            icon: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 70, 67, 67),
                            ))
                      ],
                    ),
                  ),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //Add
  Future<void> addSong() async {
    await SQLHelper.addSong(titleController.text, artistController.text,
        yearController.text, genreController.text);
    refreshSongs();
  }

  //Update
  Future<void> updateSongs(int id) async {
    await SQLHelper.updateSongs(id, titleController.text, artistController.text,
        yearController.text, genreController.text);
    refreshSongs();
  }

  //Delete
  void deleteSong(int id) async {
    await SQLHelper.deleteSong(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delete Song List Success")));
    refreshSongs();
  }

  //Add
  void modalForm(int id) async {
    if (id != null) {
      final dataSongs = songs.firstWhere((element) => element['id'] == id);
      titleController.text = dataSongs['title'];
      artistController.text = dataSongs['artist'];
      yearController.text = dataSongs['year'];
      genreController.text = dataSongs['genre'];
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(249, 138, 138, 138),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 775,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ))),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                        controller: artistController,
                        decoration: InputDecoration(
                            labelText: "Artist",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                        controller: yearController,
                        decoration: InputDecoration(
                            labelText: "Year",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                        controller: genreController,
                        decoration: InputDecoration(
                            labelText: "Genre",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await addSong();
                          } else {
                            await updateSongs(id);
                          }

                          // await addSong();
                          titleController.text = '';
                          artistController.text = '';
                          yearController.text = '';
                          genreController.text = '';
                          Navigator.pop(context);
                        },
                        child: Text(
                            id == null ? 'Add Song List' : 'Update Song List'))
                  ],
                ),
              ),
            ));
  }
}
