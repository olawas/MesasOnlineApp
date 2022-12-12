const controller = require('../controllers/System_controller.js')
const express = require('express')
const router = express.Router()
const authorize = require('../controllers/auth_controller.js')

//PRODUCTOS
//Crea nuevo Producto
router.post('/', controller.creaProducto)
//Edita producto en base a Id
router.put('/:id', controller.actualizaProducto)
//Buscar Producto
router.get('/get', controller.buscaProducto)
//Eliminar Producto 
router.delete('/:id', controller.eliminaProducto)
//Actualizar stock rol vendedor
router.put('/venta/:id', controller.actualizaStockV)

//USUARIOS
//crear nuevo usuario
router.post('/user/post', controller.creaUsuario)
//Eliminar usuario
router.delete('/user/delete', controller.eliminarUsuario)

//Autorizar y Autenticar rolAdmin y rolVendedor
router.get('/user', authorize(['admin']), function(req,res,next){
  res.json('authorized user')
})
router.get('/user/vend', authorize(['vend']), function(req,res,next){
  res.json('authorized user')
})

module.exports = router;