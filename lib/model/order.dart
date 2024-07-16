import 'package:hotdog_pedidos/model/item.dart';
import 'package:intl/intl.dart';

class Order {

  static int _ORDER_ID = 1;

  static void reset(){
    _ORDER_ID = 1;
  }

  Order(){
    _id = _ORDER_ID++;
  }

  late int _id;
  final Map<Item, int> _itemsOrdered = {};
  final DateTime _dateOrdered = DateTime.now();
  bool _isDelivered = false;
  bool _isEatIn = true;
  String _notes = "";
  double _totalPrice = 0;

  void addItem(Item item){
    
    if(_itemsOrdered.containsKey(item)){
      _itemsOrdered.update(item, (count) => count + 1);
    }else{
      _itemsOrdered[item] = 1;
    }
    _totalPrice += item.getPrice();
  }

  void removeItem(Item item){
    if(_itemsOrdered.containsKey(item) && _itemsOrdered[item]! > 0){
      _itemsOrdered.update(item, (count) => count - 1);
      _totalPrice -= item.getPrice();
      if(_itemsOrdered[item] == 0){
        _itemsOrdered.remove(item);
      }
    }
  }

  int getTotalOfItem(Item item){
    if(_itemsOrdered.containsKey(item)){
      return _itemsOrdered[item]!;
    }else {
      return 0;
    }
  }

  int getTotalOfType(int type){
    int countOfType = 0;
    _itemsOrdered.forEach((item, count) { 
      if(item.getType() == type){
        countOfType += count;
      }
    });
    return countOfType;
  }

  String getOrderHeader(){
    DateFormat dateFormat = DateFormat("HH:mm");
    String title = "${dateFormat.format(_dateOrdered)} - Pedido nº $_id";
    return title;
  }

  String getOrderDescription(){
    String description = "";
    _itemsOrdered.forEach((item, count) { 
      description += "${count}x ${item.getName()}\n";
    });
    if(_notes.isNotEmpty){
      description += "\nObservações: ";
      description += _notes;
    }
    description += _isEatIn ? "\nCOMER" : "\nLEVAR";
    return description;
  }

  // Getters and Setters
  String getNotes(){
    return _notes;
  }

  void setNotes(String notes){
    _notes = notes;
  }

  double getTotalPrice(){
    return _totalPrice;
  }

  int getId(){
    return _id;
  }

  bool getIsDelivered(){
    return _isDelivered;
  }

  void setIsDelivered(bool isDelivered){
    _isDelivered = isDelivered;
  }

  bool getIsEatIn(){
    return _isEatIn;
  }

  void setIsEatIn(bool isEatIn){
    _isEatIn = isEatIn;
  }
}
