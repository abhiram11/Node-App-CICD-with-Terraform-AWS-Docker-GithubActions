const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Abhiram's app is running!");
});

app.listen(8080, () => {
  console.log("Server is running on 8080 !!");
});
