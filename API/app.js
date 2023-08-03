import express from "express";
import axios from "axios";

const app = express();
app.use(express.json());
const port = 3000

// Punto 1
app.get('/api/', (req, res) => {
  res.status(200).json({message: 'Hello World!'})
})

// Punto 2
app.get('/api/suma/', (req, res) => {
  const { num1, num2 } = req.query;
  const sum = num1 + num2;
  res.status(200).json({result: sum})
})

// Punto 3
app.get('/api/user/:name', (req, res) => {
  const { name } = req.params;
  res.status(200).json({user: name})
})

// Punto 4
app.get('/api/swapi/:id', async(req, res) => {
  const {id} = req.params;

  try {
    const response = await axios.get(`https://swapi.dev/api/people/${id}/`);
    if(response.status === 200) {
      return res.status(200).json({personaje: response.data});
    }

  } catch (error) {
    return res.status(400).json({error: error.message})
  }
})

// Punto 5
app.put('/api/body/', (req, res) => res.status(200).json(req.body))

// Punto 6
app.post('/api/suma/', (req, res) => {
  const { num1, num2 } = req.body;
  const sum = num1 + num2;
  res.status(200).json({result: sum})
})

// Punto 7
app.delete('/api/delete/:id', (req, res) => {
  const { id } = req.params;
  if(id !== '3') return res.status(404).send('No se encontró el objeto con el ID especificado');
  return res.status(200).send(`Se ha eliminado el objeto con ID ${id}`)
})

// Punto 8
app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
