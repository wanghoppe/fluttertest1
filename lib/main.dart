import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Startup Name Generator'),
            actions: <Widget>[      // Add 3 lines from here...
            IconButton(icon: Icon(Icons.list)),
            ],                      // ... to here.
          ),
          body:MultiProvider(
            providers:[
              Provider(
                create: (context) => ListModel()
              ),
              ChangeNotifierProvider<SavedModel>(
                create: (context) => SavedModel()
              )
            ],
            child: Column(
              children: [
                Expanded(
                  flex:2,
                  child: MyListView()
                ),
                Expanded(
                  flex:1,
//                  height: 200,
                  child: SavedListView()
                )
                ],
              )
            ),
          )
      );
  }
}

class SavedListView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var saveModel = Provider.of<SavedModel>(context);
    var rowLst = saveModel.saved.toList();
    print('[Saved] rebuild saved list');
    return ListView.builder(
        itemCount: rowLst.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, idx) {
          var row = rowLst[idx];
          return ListTile(
            title: Text(
              rowLst[idx],
            ),
          );
        }
    );
  }
}

class MyImage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/1.jpg',
            ),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.0),
                Colors.white,
              ],
          )),
      )
    ]);
  }

}


class MyListView extends StatefulWidget {

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {

  double scrollPos = 0.0;
  final myList = MySecondListView();
  final backImg = MyImage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        FractionallySizedBox(
          heightFactor: 0.8,
          widthFactor: 1.3 - min(scrollPos/200, 0.3),
          child: Padding(
//              padding: EdgeInsets.all(0),
            padding: EdgeInsets.only(bottom: scrollPos),
            child: Opacity(
              opacity: 1.0 - min(scrollPos/250, 1),
              child: backImg
            ),
          ),
        ),
        Container(
          child: NotificationListener<ScrollUpdateNotification>(
            child: myList,
            onNotification: (note){
//              print(note.scrollDelta);
//              print(note.metrics.pixels);
              setState(() {
                scrollPos = note.metrics.pixels;
              });
              return true;
            },
          ),
        )
      ]
    );
  }
}

class MySecondListView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var myModel = Provider.of<ListModel>(context);
    var rowLst = myModel.rowLst;
    return ListView.builder(
        itemCount: rowLst.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, idx) {
          if (idx == 0) return Container(height: 200);
          var row = rowLst[idx-1];
          return ChangeNotifierProvider<RowItem>.value(
              value: row,
              child: ItemRow()
          );
        }
    );
  }

}

class ItemRow extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  ItemRow();

  @override
  Widget build(BuildContext context) {

    var rowModel = Provider.of<RowItem>(context);
    var alreadySaved = rowModel.added == 1;
    var saveModel = Provider.of<SavedModel>(context, listen: false);

    print('[Item] build ${rowModel.title} item');
    return ListTile(
      title: Text(
        rowModel.title,
        style: _biggerFont,
      ),
      trailing: IconButton(
        icon: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onPressed: (){
          rowModel.updateAdd();
          if (alreadySaved){
            saveModel.deleteItem(rowModel.title);
          }else{
            saveModel.addItem(rowModel.title);
          }
        },
      ),    // ... to here.
    );
  }
}