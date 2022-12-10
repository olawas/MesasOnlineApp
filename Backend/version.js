var express = require('express');
var router = express.Router();
var version = 1
router.get('/', function(req, res, _) {
res.json({version: version})
})
router.put('/', function(req, res, __){
    version = req.body.version
    res.status(200).json({message: 'OK'})
})
module.exports = router;