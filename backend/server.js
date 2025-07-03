const express = require('express');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

const app = express();
const port = process.env.PORT || 3001; // Backend typically runs on a different port than frontend

app.get('/', (req, res) => {
  res.send('Car Sales Backend API');
});

app.listen(port, () => {
  console.log(`Backend server listening at http://localhost:${port}`);
});
