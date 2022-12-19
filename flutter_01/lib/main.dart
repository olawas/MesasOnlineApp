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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
List? carritoCompras = [];
List? mesasLista = [];
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
  bool _value = false;
  
  void saveData(int index){
    carritoCompras?.add(productosData?[index]);
    debugPrint("$carritoCompras");
  }
  void comandaWidget(){

  }
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
        await http.get(Uri.parse('http://localhost:3000/mesas/get'));
      setState(() {
      mesasLista = json.decode(response.body) as List;
    });
  }

  @override
  initState() {
    super.initState();
    getProductos();
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
          backgroundColor: Color.fromARGB(255, 199, 151, 48),
        ),
        body: 
        ListView.builder(
            itemCount: productosData?.length,
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
                                text: 'Name: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${productosData?[index]["nombre"].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Unit: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${productosData?[index]["stock"].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Price: ' r"$",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${productosData?[index]["precio"].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey.shade900),
                        onPressed: () {
                          saveData(index);
                        },
                        child: const Text('Add to Cart')),
                  ],
                ),
              ),
            );
    }),
    floatingActionButton: FloatingActionButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>ComandaWidget())),
    ),
  );
  }
}
class ComandaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comanda"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: ListView.builder(
            itemCount: carritoCompras?.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(color: Colors.blueGrey.shade200,
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
                                text: 'Name: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${carritoCompras?[index]["nombre"].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Price: ' r"$",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${carritoCompras?[index]["precio"].toString()}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
            }
          )
        ),
      ),
    );
  }
}
class MesasWidget extends StatelessWidget {

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
            itemCount: carritoCompras?.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(color: Colors.blueGrey.shade200,
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
                                text: 'Price: ' r"$",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${mesasLista?[index]["estado"].toString()}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
            }
          )
        ),
      ),
    );
  }
}
