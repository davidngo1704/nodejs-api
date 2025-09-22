const express = require("express");
const app = express();
const port = 3000;

// Middleware để parse JSON
app.use(express.json());

// Route test
app.get("/", (req, res) => {
  res.send("Đại đẹp trai");
});

// Ví dụ API GET
app.get("/hello/:name", (req, res) => {
  res.json({ message: `Xin chào ${req.params.name}` });
});

// Ví dụ API POST
app.post("/echo", (req, res) => {
  res.json({ youSent: req.body });
});

// Start server
app.listen(port, () => {
  console.log(`Server đang chạy tại http://localhost:${port}`);
});
