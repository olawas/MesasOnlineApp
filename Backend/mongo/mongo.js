var mongoose = require('mongoose');

const init = async () => {
  try{
    await mongoose.connect(process.env.DB_URL)
    console.log('connected')
  }
  catch(err){
    console.error('error: ' + err.stack);
    process.exit(1);
   }
};

module.exports = init