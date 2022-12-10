'use strict';
var jwt = require("jsonwebtoken")
var {usuarios} = require('../models/Schemas.js')

const authorize = (roles) =>
 function(req, res, next) {
  const token =
    req.body.token || req.query.token || req.headers["x-access-token"];

  if (!token) {
    return res.status(403).send("Se necesita un token para autentificar");
  }
  try {
    const decoded = jwt.verify(token, process.env.JWT_KEY);
    console.log(decoded)
    if(roles.length > 0){
      
      usuarios.findOne({nombre: decoded.nombre})
      .then((usuario) => {
        let allowed = false 
        console.log(usuario.roles, usuario.nombre)
        for (const r of usuario.roles){
          if (roles.includes(r))
            allowed = true
        }
        if (allowed){
          return next()
        }else{
          console.log('Usuario no tiene permisos para ingresar como '+ roles)
          return res.json('Usuario no tiene permisos para ingresar como '+ roles)
          
        }
      })
    }else{
      return next()
      }
  } catch (err) {
    return res.status(401).send("Token invalido");
  }
};


module.exports = authorize
