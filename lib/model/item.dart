abstract class Item {
  
  static const HOTDOG = 1, DRINK = 2;

  Item(this._name, this._price, this._type);

  final String _name;
  final double _price;
  final int _type;

  String getName(){
    return _name;
  }

  double getPrice(){
    return _price;
  }

  int getType(){
    return _type;
  }
}


