const mongoose = require('mongoose');

const mongo_uri = process.env.MONGODB_URL || 'mongodb://127.0.0.1:27017/';

mongoose.connect(mongo_uri , { useNewUrlParser: true, useUnifiedTopology: true 
})