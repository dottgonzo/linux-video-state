var netw=require('../index.js'),
verb=require("verbo");

netw.data().then(function(doc){

if(doc){


verb(JSON.stringify(doc),"debug","Data");


} else{
  verb("data problems","error","Aurorajs");
  process.exit(1);

}
})
