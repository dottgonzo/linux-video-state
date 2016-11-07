import video from "../index";

video().then(function (doc) {
  console.log(JSON.stringify(doc));
}).catch(function (err) {
  console.log(err);
});
