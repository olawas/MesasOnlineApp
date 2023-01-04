/*
  Lista de funcionalidades a aplicar:
    * Acceder a la camara: 
    * Crear QR para una mesa:
    * Poder ingresar a mesa con QR creado:
    * Llamar a los productos desde la bd: Completado
    * Bajar stock a medida que se cobra:
    * Notificacion a Mesero  cuando se realiza un pedido:
  
  Widgets a crear:
    * Mesa (Lista de productos, con boton para seleccionar el deseado)
    * Comanda (Lista de productos seleccionados por el cliente, 
      con opcion de cambiar cantidad mostrando el total, boton de Ordenar!)
    * Acceso Mesa (Se accede a la camara y lee el QR para acceder a la mesa
      correspondiente)
    * Mesero  (Muestra las mesas {Ocupada, Disponible}, con sus respectivos 
      botones para crear QR o cobrar)
    * Cobrar Mesero  (Muestra el precio total a cobrar al cliente mas un boton precio
      donde el Mesero  indica que se realizo el cobro)
*/

import 'dart:html';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

List carritoCompras = [];
List? cantidadComprar = [];
List? mesasLista;

void main() {
  runApp(
    MaterialApp(home: HomePage()),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map? data;
  List? productosData;

  void buttonA() {
    debugPrint("Se apretooo");
  }

  /*void checkListA(x){
    setState(() {
      _value = x;
    });
  }*/
  getProductos() async {
    http.Response response =
        await http.get(Uri.parse('http://localhost:3000/mongo/get'));
    setState(() {
      productosData = json.decode(response.body) as List;
      
    });
  }

  getMesas() async {
    http.Response response =
        await http.get(Uri.parse('http://localhost:3000/mongo/mesa/get'));
    setState(() {
      mesasLista = json.decode(response.body) as List;
      print("\nMesas: \n");
      print(mesasLista?.length);
      print(mesasLista?[0]["estado"]);

    });
  }

  getIdCarrito(i) {
    var find = carritoCompras.firstWhere(
        (element) => element["id"] == productosData?[i]["_id"],
        orElse: () => false);
    if (find == false) {
      return false;
    } else {
      return true;
    }
  }

  @override
  initState() {
    super.initState();
    getProductos();
    getMesas();
  }

  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Carta'),
              actions: <Widget>[
                IconButton(onPressed: (){ Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrincipalWidget()));}, icon: Icon(Icons.add_to_home_screen_sharp))
              ],
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "Platos",
                  ),
                  Tab(
                    text: "Jugos",
                  ),
                  Tab(
                    text: "Alcoholes",
                  ),
                ],
              ),
              backgroundColor: Color.fromARGB(255, 199, 151, 48),
            ),
            body: TabBarView(children: <Widget>[
              Center(
                child: ListView.builder(
                    itemCount: productosData?.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (productosData?[index]["tipo"] == "1") {
                        var selected = false;
                        const bool select = true;
                        return Card(
                          color: Colors.blueGrey.shade200,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Nombre: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${productosData?[index]["nombre"].toString()}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Quedan: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${productosData?[index]["stock"].toString()}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Precio: ' r"$",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${productosData?[index]["precio"].toString()}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey.shade900),
                                  onPressed: () {
                                    setState(() {
                                      if (getIdCarrito(index)) {
                                        carritoCompras.removeWhere((element) =>
                                            element["id"] ==
                                            productosData?[index]["_id"]);
                                      } else {
                                        carritoCompras.add({
                                          'id': productosData?[index]["_id"],
                                          'nombre': productosData?[index]
                                              ["nombre"],
                                          'precio': 
                                            productosData?[index]["precio"]
                                          ,
                                          'stock': productosData?[index]
                                              ["stock"],
                                          'cantidad': 1
                                        });
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: (getIdCarrito(index))
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text("");
                    }),
              ),
              Center(
                child: ListView.builder(
                    itemCount: productosData?.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (productosData?[index]["tipo"] == "2") {
                        return Card(
                          color: Colors.blueGrey.shade200,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Nombre: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${productosData?[index]["nombre"].toString()}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Quedan: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${productosData?[index]["stock"].toString()}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Precio: ' r"$",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${productosData?[index]["precio"].toString()}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey.shade900),
                                  onPressed: () {
                                    setState(() {
                                      if (getIdCarrito(index)) {
                                        carritoCompras.removeWhere((element) =>
                                            element["id"] ==
                                            productosData?[index]["_id"]);
                                      } else {
                                        carritoCompras.add({
                                          'id': productosData?[index]["_id"],
                                          'nombre': productosData?[index]
                                              ["nombre"],
                                          'precio': 
                                            productosData?[index]["precio"]
                                          ,
                                          'stock': productosData?[index]
                                              ["stock"],
                                          'cantidad': 1
                                        });
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: (getIdCarrito(index))
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text("");
                    }),
              ),
              Center(
                child: ListView.builder(
                    itemCount: productosData?.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (productosData?[index]["tipo"] == "3") {
                        return Card(
                          color: Colors.blueGrey.shade200,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Nombre: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${productosData?[index]["nombre"].toString()}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Quedan: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${productosData?[index]["stock"].toString()}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Precio: ' r"$",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${productosData?[index]["precio"].toString()}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey.shade900),
                                  onPressed: () {
                                    setState(() {
                                      if (getIdCarrito(index)) {
                                        carritoCompras.removeWhere((element) =>
                                            element["id"] ==
                                            productosData?[index]["_id"]);
                                      } else {
                                        carritoCompras.add({
                                          'id': productosData?[index]["_id"],
                                          'nombre': productosData?[index]
                                              ["nombre"],
                                          'precio': 
                                            productosData?[index]["precio"]
                                          ,
                                          'stock': productosData?[index]
                                              ["stock"],
                                          'cantidad': 1
                                        });
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: (getIdCarrito(index))
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text("");
                    }),
              ),
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ComandaWidget()))
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.checklist_sharp),
            )));
  }
}
class PrincipalWidget extends StatelessWidget{
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Principal"),
        actions: <Widget>[
          IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(Icons.add_to_home_screen_sharp))
        ],
      ),
      body: Center(
        child: Text(
        "Bienvenido a MesasOnlineApp",
        style: TextStyle(
          color: Colors.black,
          fontSize: 40.0,
        ),
      ),
    ),
    floatingActionButton: ButtonTheme(
        minWidth: 400,
        height: 500,
        child:ElevatedButton.icon(
        label: Text("Soy Garzon"),
        style: ElevatedButton.styleFrom(
                fixedSize: const Size(240, 80), backgroundColor: Colors.deepOrange),
        icon: Icon(Icons.arrow_circle_right_sharp),
        onPressed: () => {
          Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MesasWidget()))
          
        },
      )),
    );
  }
}
class ComandaWidget extends StatelessWidget {
  String getCantidad(a) {
    return carritoCompras[a]["cantidad"].toString();
  }
  int getTotal(){
    int total = 0;
    carritoCompras.forEach((element) {
      int precio = element["precio"];
      int cantidad = element["cantidad"];
      total += precio*cantidad;
      
    });
    return total;
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comanda"),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: carritoCompras.length,
            itemBuilder: (BuildContext contex1, int index) {
              //cantidad?[index] = 1;
              return Card(
                color: Colors.blueGrey.shade200,
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5.0,
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              text: TextSpan(
                                  text: 'Nombre: ',
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade800,
                                      fontSize: 16.0),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${carritoCompras[index]["nombre"].toString()}\n',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                            RichText(
                              maxLines: 1,
                              text: TextSpan(
                                  text: 'Precio: ' r"$",
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade800,
                                      fontSize: 16.0),
                                  children: [
                                    TextSpan(
                                        text: carritoCompras[index]["precio"]
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      FloatingActionButton(
                          onPressed: () {
                            carritoCompras[index]["cantidad"]--;
                            (context as Element).markNeedsBuild();
                            
                          },
                          child: const Icon(Icons.remove)),
                      Text(getCantidad(index)),
                      FloatingActionButton(
                          onPressed: () {
                            carritoCompras[index]["cantidad"]++;
                            (context as Element).markNeedsBuild();
                          },
                          child: const Icon(Icons.add)),
                    ],
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: ButtonTheme(
        minWidth: 400,
        height: 500,
        child:ElevatedButton.icon(
        label: Text(getTotal().toString()),
        style: ElevatedButton.styleFrom(
                fixedSize: const Size(240, 80), backgroundColor: Colors.deepOrange),
        icon: Icon(Icons.arrow_circle_right_sharp),
        onPressed: () => {
          
          (context as Element).markNeedsBuild(),
          Navigator.pop(context)
        },
      )),

    );
  }
}
class ComandaMesasWidget extends StatelessWidget {
  String getCantidad(a) {
    return carritoCompras[a]["cantidad"].toString();
  }
  int getTotal(){
    int total = 0;
    carritoCompras.forEach((element) {
      int precio = element["precio"];
      int cantidad = element["cantidad"];
      total += precio*cantidad;
      
    });
    return total;
    
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comanda Mesa 1"),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: carritoCompras.length,
            itemBuilder: (BuildContext contex1, int index) {
              //cantidad?[index] = 1;
              return Card(
                color: Colors.blueGrey.shade200,
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5.0,
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              text: TextSpan(
                                  text: 'Nombre: ',
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade800,
                                      fontSize: 16.0),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${carritoCompras[index]["nombre"].toString()}\n',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                            RichText(
                              maxLines: 1,
                              text: TextSpan(
                                  text: 'Precio: ' r"$",
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade800,
                                      fontSize: 16.0),
                                  children: [
                                    TextSpan(
                                        text: carritoCompras[index]["precio"]
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    
                      Text(getCantidad(index)),
                      
                    ],
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: ButtonTheme(
        minWidth: 400,
        height: 500,
        child:ElevatedButton.icon(
        label: Text("Cobrar: "+getTotal().toString()),
        style: ElevatedButton.styleFrom(
                fixedSize: const Size(240, 80), backgroundColor: Color.fromARGB(255, 34, 255, 63)),
        icon: Icon(Icons.arrow_circle_right_sharp),
        onPressed: () => {
          
          carritoCompras.forEach((element) => {
                  http.put(
                  Uri.parse('http://localhost:3000/mongo/'+ element["id"]),
                  body: jsonEncode(<String, int>{
                    'stock': (element["stock"] - element["cantidad"]),
                  }),
                  
              ),
              print(element["stock"] - element["cantidad"]),
          }),
          mesasLista?[0] = false,
          (context as Element).markNeedsBuild(),
          
          Navigator.pop(context)

        },
      )),

    );
  }
}
class MesasWidget extends StatelessWidget {
  String getEstadoMesa(index) {
    if (mesasLista?[index]["estado"] == false) {
      return "Disponible";
    } else {
      return "En uso";
    }
  }

  int contStock = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MESAS"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: ListView.builder(
                itemCount: mesasLista?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.blueGrey.shade200,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 130,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5.0,
                                ),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  text: TextSpan(
                                      text: 'Numero Mesa: ',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade800,
                                          fontSize: 16.0),
                                      children: [
                                        TextSpan(
                                            text:
                                                '${mesasLista?[index]["numero"].toString()}\n',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                ),
                                RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                      text: 'Estado: ',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade800,
                                          fontSize: 16.0),
                                      children: [
                                        TextSpan(
                                            text: 'En uso',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          ButtonTheme(
                            minWidth: 400,
                            height: 500,
                            child:ElevatedButton.icon(
                            label: Text("Ver Comanda"),
                            style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(240, 80), backgroundColor: Color.fromARGB(255, 170, 255, 34)),
                            icon: Icon(Icons.arrow_circle_right_sharp),
                            onPressed: () => {
                              Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ComandaMesasWidget()))
                              
                            },
                          )),
                          
                        ],
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}