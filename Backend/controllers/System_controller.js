const {Productos, usuarios, Mesas} = require('../models/Schemas')

exports.creaUsuario = async function(req,res){
    const usuario = new usuarios({
        nombre: req.body.nombre,
        contra: req.body.contra,
        roles: req.body.roles
    })
    const usuarioSaved = await usuario
    .save(usuario)
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "un error ha sucedido al guardar"
      });
    });
    console.log("Se ha creado "+usuarioSaved.nombre)
}
exports.creaProducto = async function(req,res) {
    const producto = new Productos({
        nombre: req.body.nombre,
        precio: req.body.precio,
        stock: req.body.stock
    })
    const productoSaved = await producto
    .save(producto)
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "un error ha sucedido al guardar producto"
      })
    })
    console.log("Se ha creado "+ productoSaved.nombre)
}

exports.actualizaProducto = async function(req, res){
    //validar elemento no vacio
    if (!req.body) {
        return res.status(400).send({
            message: "Los datos para actualizar no pueden ser vacios."
        });
    }
    const id = req.params.id;
    const productoNuevo = await Productos.findByIdAndUpdate(id, req.body, { useFindAndModify: false })
    .then(data => {
    if (!data) {
        res.status(404).send({
            message: "No se puede actualizar el producto con id = "+id+". Quizas el producto no exista."
        });
    }else res.send({ message: "Producto acualizado correctamaente." });
    })
    .catch(err => {
        res.status(500).send({
            message: "Error al actualizar producto con la id = " + id
        });
    });
    console.log(productoNuevo)
};

exports.actualizaStockV = async function(req,res,_){
  
  const productoEd = await Productos.findOneAndUpdate({_id: req.params.id}, {stock: req.body.stock})
  res.status(200)
  console.log(productoEd)
}

exports.buscaProducto = async function(req, res, _){
  
    const producto = await Productos.find()
    //res.send(producto)
    res.json(producto)
}

exports.eliminaProducto = async function(req,res,_){
    const producto = await Productos.findOneAndDelete({_id: req.params.id})
    console.log("Eliminando " + producto.nombre)
    if(producto){
      await producto.remove()
    }else{
      console.log("Producto null")
    }
}

exports.eliminarUsuario = async function(req, res, _){
    const user = await usuarios.findOneAndDelete({_id: '6372639c6de332a5499ca24f'})
    res.send("Se elimino " + user)
}

exports.crearMesa = async function(req,res,_){
  const mesa = new Mesas({
    numero: req.body.numero
  })
}

exports.getMesas = async function(req,res,_){
  const mesas = await Mesas.find()
  res.json(mesas)
}