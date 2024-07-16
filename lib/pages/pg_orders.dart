import 'package:flutter/material.dart';
import 'package:hotdog_pedidos/controller/ctrl_order.dart';
import 'package:hotdog_pedidos/model/order.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, required this.isDelivered});

  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    OrderController orderController =
        Provider.of<OrderController>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Order currentOrder = isDelivered
                    ? orderController.getDeliveredOrder(index)
                    : orderController.getAwaitingOrder(index);
                return _CheckboxExpansionTile(
                  currentOrder: currentOrder,
                  orderController: orderController,
                  isDelivered: isDelivered,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 5,
                );
              },
              itemCount: isDelivered
                  ? orderController.getDeliveredOrderTotal()
                  : orderController.getAwaitingOrderTotal(),
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckboxExpansionTile extends StatelessWidget {
  const _CheckboxExpansionTile(
      {required this.currentOrder,
      required this.orderController,
      required this.isDelivered});

  final Order currentOrder;
  final OrderController orderController;
  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.all(10),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.topLeft,
      leading: isDelivered
          ? IconButton(onPressed: () => orderController.updateOrderStatus(currentOrder, false), icon: const Icon(Icons.undo))
          : IconButton(onPressed: () => orderController.updateOrderStatus(currentOrder, true), icon: const Icon(Icons.check_circle_outline)),
      title: Text(currentOrder.getOrderHeader()),
      children: [
        Text(textAlign: TextAlign.start, currentOrder.getOrderDescription()),
        const Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Total: R\$"),
                Text(currentOrder.getTotalPrice().toStringAsFixed(2)),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: 
              [
                if(!isDelivered)
                IconButton(
                    onPressed: () {
                      orderController.updateOrder(currentOrder);
                      Navigator.pushNamed(context, "/ordering");
                    },
                    icon: const Icon(Icons.edit)),
                if(!isDelivered)
                IconButton(
                    onPressed: () {
                      orderController.deleteOrder(currentOrder);
                    },
                    icon: const Icon(Icons.delete)),
                if(isDelivered)
                IconButton(
                    onPressed: () {
                      orderController.updateOrderStatus(currentOrder, false);
                    },
                    icon: const Icon(Icons.undo)),
              ],
            )
          ],
        )
      ],
    );
  }
}
