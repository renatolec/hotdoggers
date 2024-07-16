import 'package:hotdog_pedidos/model/drink.dart';
import 'package:hotdog_pedidos/model/hotdog.dart';
import 'package:hotdog_pedidos/model/item.dart';

class Menu {
  static List<Item> menuItems = [
    Hotdog("Simples", 15, Item.HOTDOG,
        [true, true, true, true, true, false, false, false], false),
    Hotdog("Simples Duplo", 17, Item.HOTDOG,
        [true, true, true, true, true, false, false, false], true),
    Hotdog("Especial", 23, Item.HOTDOG,
        [true, true, true, true, true, true, true, true], false),
    Hotdog("Especial Duplo", 25, Item.HOTDOG,
        [true, true, true, true, true, true, true, true], true),
    Drink("Coca", 5, Item.DRINK),
    Drink("Coca Zero", 5, Item.DRINK),
    Drink("Fanta", 5, Item.DRINK),
    Drink("Guaraná", 5, Item.DRINK),
    Drink("Sprite", 5, Item.DRINK),
    Drink("Água", 2.5, Item.DRINK),
  ];

  static void sortMenu() {
    menuItems.sort((a, b) {
      return a.getType().compareTo(b.getType());
    });
  }

  static List<Item> listByType(int type) {
    List<Item> itemsByType = [];
    for (int i = 0; i < menuItems.length; i++) {
      if (menuItems[i].getType() == type) {
        itemsByType.add(menuItems[i]);
      }
    }
    return itemsByType;
  }

  static Item getByType(int index, int type) {
    for (int i = 0; i < menuItems.length; i++) {
      if (menuItems[i].getType() == type) {
        index += i;
        break;
      }
    }
    return menuItems[index];
  }
}
