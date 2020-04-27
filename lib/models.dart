
import 'package:flutter/material.dart';

class ListModel {
  static const _itemNames = [
    'Code Smell',
    'Control Flow',
    'Interpreter',
    'Recursion',
    'Sprint',
    'Heisenbug',
    'Spaghetti',
    'Hydra Code',
    'Off-By-One',
    'Scope',
    'Callback',
    'Closure',
    'Automata',
    'Bit Shift',
    'Currying',
  ];

  List<RowItem> rowLst = _itemNames.map((e){
    var row = RowItem();
    row.title = e;
    row.added = 0;
    return row;
  }).toList();

//  Item getById(int id) => Item(id, _itemNames[id % _itemNames.length]);
//
//  /// Get item by its position in the catalog.
//  Item getByPosition(int position) {
//    // In this simplified case, an item's position in the catalog
//    // is also its id.
//    return getById(position);
//  }
}

class RowItem extends ChangeNotifier{
  var title;
  var added;

  void updateAdd(){
    added = 1-added;
    notifyListeners();
  }
}

class SavedModel extends ChangeNotifier{
  final saved = Set<String>();

  void addItem(String title){
    saved.add(title);
    notifyListeners();
  }

  void deleteItem(String title){
    saved.remove(title);
    notifyListeners();
  }

}

