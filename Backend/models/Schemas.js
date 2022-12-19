//const express = require('express')

const {Schema, model} = require('mongoose')
var bcrypt = require("bcrypt")


const ProductSchema = new Schema(
    {
        nombre : {
            type: String, 
            required: true
        },
        precio : {
            type: Number,
            required: true
        },
        stock: {
            type: Number, 
            required: true
        },
        medida: {
            type: String,
            required: true
        },
        cantidad: {
            type: Number,
            required: false
        }
    },
    { timestamps: true },
)

const UsuarioSchema = new Schema({
    nombre:{
        type: String,
        required: [true, 'UserName is mandatory']
    },
    contra:{
        type: String,
        required: [true, 'Password is mandatory']
    },
    roles: {
        type: [String],
        required: [true, 'Roles is mandatory'],
    },
    token: {
        type: String,
        required: [false, 'Session token is not mandatory'],
        default: ''
    }
},
{ timestamps: true },)

const MesaSchema = new Schema({
    numero:{
        type: String,
        required:[true,'Numero de mesa is required']
    },
    estado:{
        type: Boolean,
        required:[false, 'Estado is not mandatory'],
        default: false
    }
},{ timestamps: true },)

UsuarioSchema.pre('save', function(next) {
    var user = this
    if(!user.isModified('contra')){
        return next()
    } 
    bcrypt.genSalt(10, function(err, salt) {
        if(err){
            return next(err)
        }
        bcrypt.hash(user.contra, salt, function (err,hash) {
            if(err){
                return next(err);
            }
            user.contra = hash
            next()
        })
    })
})


UsuarioSchema.methods.comparePassword = function(contra) {
    return bcrypt.compareSync(contra, this.contra)
}

const usuarios = model('User',UsuarioSchema)
const Productos = model('Prod', ProductSchema)
const Mesas = model('Mesas', MesaSchema)
module.exports = {Productos, usuarios, Mesas}



