var memrun=require('memrun'),
Promise = require('promise');



function override(){
  return {
    _id:'networklog',
    dbtype:"networklog",
    apiVersion:require(__dirname+'/package.json').apiVersion
  }
}

module.exports = {
  pure:function(){
    return new Promise(function (resolve, reject) {
    memrun.pure(__dirname+'/video.sh').then(function(data){
      resolve(data);
    }).catch(function(err){
      reject(err)
    });
    });
  },
  data:function(){
    return new Promise(function (resolve, reject) {

    memrun.data(__dirname+'/video.sh',override()).then(function(data){
    resolve(data);
  }).catch(function(err){
    reject(err)
  });
    });
  },
save:function(db){
  return new Promise(function (resolve, reject) {

  memrun.save(__dirname+'/video.sh',db,override()).then(function(data){
  resolve(data);
}).catch(function(err){
  reject(err)
});
});
},
ifchangesave:function(db){
  return new Promise(function (resolve, reject) {

  memrun.ifchangesave(__dirname+'/video.sh',db,override()).then(function(data){
  resolve(data);
}).catch(function(err){
  reject(err)
});
});
}


}
