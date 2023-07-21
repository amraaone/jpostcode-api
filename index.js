import { PrismaClient } from "@prisma/client"
import express from "express"
import * as dotenv from "dotenv"
import helmet from "helmet"
import cors from "cors"
import cookieParser from "cookie-parser"
import jpostcode from "./routes/jpostcode"

dotenv.config()

const app = express()
const prisma = new PrismaClient()
const port = process.env.PORT || 3100

app.use(express.json())
app.use(cookieParser())
app.use(helmet())

const corsOptions = {
  origin: true,
  methods: ["GET"],
  allowedHeaders: ["Content-Type", "Authorization"],
}
app.use(cors(corsOptions))
app.use("/jpostcode", jpostcode)

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`)
})
