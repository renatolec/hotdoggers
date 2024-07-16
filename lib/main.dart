import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotdog_pedidos/controller/ctrl_order.dart';
import 'package:hotdog_pedidos/pages/pg_ordering.dart';
import 'package:hotdog_pedidos/pages/pg_orders.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme appColorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(112, 18, 18, 1),
    ).copyWith(background: const Color.fromRGBO(227, 227, 227, 1));

    return ChangeNotifierProvider(
      create: (context) => OrderController(),
      child: MaterialApp(
        routes: {
          '/home': (context) => const MainSection(),
          '/ordering': (context) => const OrderingPage(),
        },
        initialRoute: '/home',
        theme: ThemeData(
            colorScheme: appColorScheme,
            textTheme: GoogleFonts.latoTextTheme(),
            appBarTheme: Theme.of(context).appBarTheme.copyWith(
                  backgroundColor: appColorScheme.primary,
                  foregroundColor: appColorScheme.onPrimary,
                ),
            expansionTileTheme: Theme.of(context).expansionTileTheme.copyWith(
                  backgroundColor: appColorScheme.surface,
                  collapsedBackgroundColor: appColorScheme.surface,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
            listTileTheme: Theme.of(context).listTileTheme.copyWith(
                  tileColor: appColorScheme.surface,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
            inputDecorationTheme:
                Theme.of(context).inputDecorationTheme.copyWith(
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: appColorScheme.surface,
                    ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    backgroundColor: appColorScheme.primary,
                    foregroundColor: appColorScheme.onPrimary)),
            bottomNavigationBarTheme: Theme.of(context)
                .bottomNavigationBarTheme
                .copyWith(backgroundColor: appColorScheme.surface),
            badgeTheme: Theme.of(context).badgeTheme.copyWith(
                  backgroundColor: appColorScheme.onPrimary,
                  textColor: appColorScheme.onBackground,
                )),
      ),
    );
  }
}

class MainSection extends StatefulWidget {
  const MainSection({super.key});

  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  int _currentPage = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      OrdersPage(
        isDelivered: false,
      ),
      OrdersPage(
        isDelivered: true,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController incomingBreadsText = TextEditingController();
    TextEditingController currentBreadsText = TextEditingController();
    OrderController orderController =
        Provider.of<OrderController>(context, listen: true);

    final breadsFormKey = GlobalKey<FormState>();
    incomingBreadsText.text = orderController.getInitBreadAmount().toString();
    currentBreadsText.text = orderController.getCurrBreadAmount().toString();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            orderController.startOrder();
            Navigator.pushNamed(context, '/ordering');
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text("Próximos pedidos"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Número de pães",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: breadsFormKey,
                            child: TextFormField(
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Insira um valor!";
                                }
                                try {
                                  int.parse(value);
                                } catch (e) {
                                  return "Insira um número válido!";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: incomingBreadsText,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  label: const Text("Estoque inicial"),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  isCollapsed: true,
                                  suffix: const Text("pães"),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        incomingBreadsText.text = "";
                                      },
                                      icon: const Icon(
                                          Icons.restart_alt_outlined))),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            controller: currentBreadsText,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              label: Text("Estoque atual"),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isCollapsed: true,
                              suffix: Text("pães"),
                            ),
                          )
                        ],
                      ),
                      actions: [
                        ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel),
                            label: const Text("Cancelar")),
                        ElevatedButton.icon(
                            onPressed: () {
                              if (breadsFormKey.currentState!.validate()) {
                                orderController.setInitBreadAmount(
                                    int.parse(incomingBreadsText.text));
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("Salvar"))
                      ],
                      actionsAlignment: MainAxisAlignment.center,
                    );
                  });
            },
            icon: Badge(
              label: Text(orderController.getCurrBreadAmount().toString()),
              child: Image.asset(
                'assets/icons/hot-dog.png',
                width: 32,
              ),
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.pending), label: "Pendentes"),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: "Entregues"),
        ],
        currentIndex: _currentPage,
        onTap: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
