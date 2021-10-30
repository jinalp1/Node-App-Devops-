const express = require('express')
const Item = require('../models/item')
const Auth = require('../middleware/auth')

const router = new express.Router()

//create an item
router.post('/items', async(req, res) => {
    try {
        const newItem = new Item(req.body)
        await newItem.save()
        res.status(201).send(newItem)
    } catch (error) {
        res.status(400).send({message: "error"})
    }
})

//update an item

router.patch('/items/:id', async(req, res) => {
    const updates = Object.keys(req.body)
    const allowedUpdates = ['name', 'description', 'category', 'price']

    const isValidOperation = updates.every((update) => allowedUpdates.includes(update))

    if(!isValidOperation) {
        return res.status(400).send({ error: 'invalid updates'})
    }

    try {
        const item = await Item.findOne({ _id: req.params.id})
    
        if(!item){
            return res.status(404).send()
        }

        updates.forEach((update) => item[update] = req.body[update])
        await item.save()
        res.send(item)
    } catch (error) {
        res.status(400).send(error)
    }
})


module.exports = router