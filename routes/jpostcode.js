import express from "express"

const router = express.Router()

router.get("/jpostcode", async (req, res) => {
  try {
    const { pc, kenkn, kukn, addkn } = req.query

    // Create a filter object based on the query parameters provided
    const filter = {}
    if (pc) {
      filter.pc = parseInt(pc)
    }
    if (kenkn) {
      filter.kenkn = { contains: kenkn }
    }
    if (kukn) {
      filter.kukn = { contains: kukn }
    }
    if (addkn) {
      filter.addkn = { contains: addkn }
    }

    // Use the 'filter' object to query the database
    const data = await prisma.data.findMany({
      where: filter,
      skip: (1 - 1) * 10,
      take: 10,
    })

    if (data.length === 0) {
      // If no data is found, send a 404 Not Found error response
      return res.status(404).json({ error: "No data found." })
    }

    return res.json(data)
  } catch (error) {
    return res
      .status(500)
      .json({ error: "An error occurred while fetching data." })
  }
})

export default router
