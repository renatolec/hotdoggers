import 'package:flutter/material.dart';
import 'package:hotdog_pedidos/controller/ctrl_order.dart';
import 'package:hotdog_pedidos/model/item.dart';
import 'package:hotdog_pedidos/model/menu.dart';
import 'package:hotdog_pedidos/model/order.dart';
import 'package:provider/provider.dart';

class OrderingPage extends StatefulWidget {
  const OrderingPage({super.key});

  @override
  State<OrderingPage> createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  @override
  Widget build(BuildContext context) {
    Menu.sortMenu();
    TextEditingController orderNotesText = TextEditingController();
    OrderController orderController =
        Provider.of<OrderController>(context, listen: false);
    Order currentOrder = orderController.getCurrentOrder();
    orderNotesText.text = currentOrder.getNotes();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Anotando pedido"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Lanches",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  Item currentItem = Menu.getByType(index, Item.HOTDOG);
                  return ListTile(
                    title: Text(currentItem.getName()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("R\$${currentItem.getPrice().toStringAsFixed(2)}"),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                currentOrder.removeItem(currentItem);
                              });
                            },
                            icon: const Icon(Icons.remove_circle_outline)),
                        Text(
                          currentOrder.getTotalOfItem(currentItem).toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                currentOrder.addItem(
                                    Menu.getByType(index, Item.HOTDOG));
                              });
                            },
                            icon: const Icon(Icons.add_circle_outline)),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext conntext, int index) {
                  return const SizedBox(
                    height: 5,
                  );
                },
                itemCount: Menu.listByType(Item.HOTDOG).length,
                shrinkWrap: true,
              ),
              const Divider(),
              Text(
                "Bebidas",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  Item currentItem = Menu.getByType(index, Item.DRINK);
                  return ListTile(
                    title: Text(currentItem.getName()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("R\$${currentItem.getPrice().toStringAsFixed(2)}"),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                currentOrder.removeItem(currentItem);
                              });
                            },
                            icon: const Icon(Icons.remove_circle_outline)),
                        Text(
                          currentOrder.getTotalOfItem(currentItem).toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                currentOrder.addItem(currentItem);
                              });
                            },
                            icon: const Icon(Icons.add_circle_outline)),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 5,
                  );
                },
                itemCount: Menu.listByType(Item.DRINK).length,
                shrinkWrap: true,
              ),
              const Divider(),
              SwitchEatInTakeOut(
                order: currentOrder,
              ),
              TextField(
                controller: orderNotesText,
                minLines: 5,
                maxLines: 5,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8.0),
                  isCollapsed: true,
                  hintText: "Observações",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) => currentOrder.setNotes(orderNotesText.text),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ListTile(
          leading: const Icon(Icons.tag),
          title: Text(
              "Total: R\$${currentOrder.getTotalPrice().toStringAsFixed(2)}"),
          trailing: ElevatedButton.icon(
              onPressed: () {
                currentOrder.setNotes(orderNotesText.text);
                orderController.createOrder(currentOrder);
                Navigator.pop(context);
                if (orderController.getCurrBreadAmount() < 20) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Cuidado!",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "Faltam ${orderController.getCurrBreadAmount()} pães"),
                            ],
                          ),
                        );
                      });
                }
              },
              icon: const Icon(Icons.save),
              label: const Text("Salvar pedido")),
        ),
      ),
    );
  }
}

class SwitchEatInTakeOut extends StatefulWidget {
  const SwitchEatInTakeOut({super.key, required this.order});

  final Order order;

  @override
  State<SwitchEatInTakeOut> createState() => _SwitchEatInTakeOutState();
}

class _SwitchEatInTakeOutState extends State<SwitchEatInTakeOut> {
  late bool isEatIn;

  @override
  Widget build(BuildContext context) {
    isEatIn = widget.order.getIsEatIn();
    return Row(
      children: [
        Switch(
            value: isEatIn,
            onChanged: (bool value) {
              setState(() {
                isEatIn = value;
                widget.order.setIsEatIn(isEatIn);
              });
            }),
        Text(isEatIn ? "Comer" : "Levar")
      ],
    );
  }
}
