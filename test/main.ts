import video = require("../index");


video().then(function(doc){




console.log(JSON.stringify(doc));


  process.exit(1);


}).catch(function(err){
    console.log(err);
})
