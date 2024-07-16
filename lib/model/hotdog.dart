import 'package:hotdog_pedidos/model/item.dart';

class Hotdog extends Item{

  static const int SAUSAGE = 0;
  static const int TOMATO = 1;
  static const int KETCHUP = 2;
  static const int MUSTARD = 3;
  static const int MAYONNAISE = 4;
  static const int BACON = 5;
  static const int HAM = 6;
  static const int CHEESE = 7;

  Hotdog(super._name, super._price, super._type, List<bool> baseIngredient, isDouble){
    _hasIngredient = baseIngredient;
    _isDouble = isDouble;
  } 

  late List<bool> _hasIngredient;
  late bool _isDouble = false;

  void setIngredient(int ingredient, bool isPresent){
    _hasIngredient[ingredient] = isPresent;
  }

  bool getIngredient(int ingredient){
    return _hasIngredient[ingredient];
  }

  void setDouble(bool isDouble){
    _isDouble = isDouble;
  }

  bool getDouble(){
    return _isDouble;
  }

  double getAdjustedPrice(){

    List<bool> specialIngredients = [
      _hasIngredient[BACON],
      _hasIngredient[HAM],
      _hasIngredient[CHEESE],
    ];

    int countOfSpecialIngredients = 0;
    for (var ingredient in specialIngredients) { 
      if(ingredient){
        countOfSpecialIngredients++;
      }
    }

    double totalPrice = 0;
    if(countOfSpecialIngredients >= 2){
      totalPrice = _isDouble ? 22 : 21;
    }else if(countOfSpecialIngredients > 0){
      totalPrice = _isDouble ? 18 : 17;
    }else{
      totalPrice = _isDouble ? 15 : 13;
    }

    return totalPrice;
  }
  
}