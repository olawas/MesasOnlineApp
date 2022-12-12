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
  getProductos() async {
    http.Response response =
        await http.get(Uri.parse('http://localhost:3000/mongo/get'));
    setState(() {
      productosData = json.decode(response.body) as List;
    });
  }

  @override
  initState() {
    super.initState();
    getProductos();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
          backgroundColor: Color.fromARGB(255, 199, 151, 48),
        ),
        body: ListView.builder(
            itemCount: productosData?.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '${productosData?[index]["nombre"]}' +
                        ': ${productosData?[index]["precio"]} pesos',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                )
              ]));
            }));
  }
}
