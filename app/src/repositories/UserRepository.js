const User = require("../models/User");

class UserRepository {
  async findAll() {
    return User.find();
  }

  async findById(id) {
    return User.findById(id);
  }

  async create(data) {
    return User.create(data);
  }
}

module.exports = new UserRepository();
