const router = require("express").Router();
const usercontroller = require("../controller/user.controller");
router.post("/registeration", usercontroller.register);
router.post("/login", usercontroller.login);

module.exports = router;
