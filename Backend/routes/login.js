var express = require('express');
var jwt = require('jsonwebtoken')
var {usuarios} = require('../models/Schemas')
var router = express.Router();

router.post('/', async function(req, res) {
     console.log(req.body)
     await usuarios.findOne({nombre: req.body.nombre})
    .then((user => {
      if (!user || !user.comparePassword(req.body.contra)) {
        console.log("Usuario o contraseña erroneos")
        return res.status(401).json({ message: 'Usuario o contraseña erroneos' })
          
      }
      const token = jwt.sign({ nombre: user.nombre, user_id: user._id, roles: user.roles}, process.env.JWT_KEY, {expiresIn: "7d"})
      user.token = token
      return res.status(200).json({ token: token, nombre: user.nombre, roles: user.roles, id: user._id});
    }))
    .catch ((error) => {
     console.log(error) 
   })
});

module.exports = router

