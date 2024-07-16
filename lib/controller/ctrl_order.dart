import 'package:flutter/material.dart';
import 'package:hotdog_pedidos/model/item.dart';
import 'package:hotdog_pedidos/model/order.dart';

class OrderController extends ChangeNotifier{

  final List<Order> _awaitingOrders = [];
  final List<Order> _deliveredOrders = [];
  late Order _currentOrder;

  int _initBreadAmount = 0;

  void createOrder(Order order){
    if(!_awaitingOrders.contains(order)){
      _awaitingOrders.add(order);
    }
    notifyListeners();
  }

  bool deleteOrder(Order order){
    bool wasRemoved = _awaitingOrders.remove(order);
    if(wasRemoved){
      notifyListeners();
    }
    return wasRemoved;
  }

  void startOrder(){
    _currentOrder = Order();
  }

  void updateOrder(Order order){
    _currentOrder = order;
  }

  Order getCurrentOrder(){
    return _currentOrder;
  }


  Order getAwaitingOrder(int index){
    return _awaitingOrders[index];
  }
 
  int getAwaitingOrderTotal(){
    _awaitingOrders.sort((a, b) {
      return a.getId().compareTo(b.getId());
    });
    return _awaitingOrders.length;
  }

  Order getDeliveredOrder(int index){
    return _deliveredOrders[index];
  }

  int getDeliveredOrderTotal(){
    _deliveredOrders.sort((a, b) {
      return a.getId().compareTo(b.getId());
    });
    return _deliveredOrders.length;
  }

  int getInitBreadAmount(){
    return _initBreadAmount;
  }

  void setInitBreadAmount(int initBreadAmount){
    _initBreadAmount = initBreadAmount;
    notifyListeners();
  }

  int getCurrBreadAmount(){
    int currBreadAmount = _initBreadAmount;
    for(Order order in _awaitingOrders){
      currBreadAmount -= order.getTotalOfType(Item.HOTDOG);
    }
    for(Order order in _deliveredOrders){
      currBreadAmount -= order.getTotalOfType(Item.HOTDOG);
    }
    return currBreadAmount;
  }
 
  void updateOrderStatus(Order order, bool status){
    if(order.getIsDelivered()){
      _deliveredOrders.remove(order);
      _awaitingOrders.add(order);
    }else{
      _awaitingOrders.remove(order);
      _deliveredOrders.add(order);
    }
    order.setIsDelivered(status);
    notifyListeners();
  }

}