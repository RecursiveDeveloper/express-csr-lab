const express = require("express");
const router = express.Router();
const UserController = require("../controllers/UserController");

router.get("/users", (req, res) => UserController.getAll(req, res));
router.get("/users/:id", (req, res) => UserController.getById(req, res));
router.post("/users", (req, res) => UserController.create(req, res));

module.exports = router;
