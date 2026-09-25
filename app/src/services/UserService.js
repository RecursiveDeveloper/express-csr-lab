const UserRepository = require("../repositories/UserRepository");

class UserService {
  async getAllUsers() {
    return UserRepository.findAll();
  }

  async getUserById(id) {
    const user = await UserRepository.findById(id);
    if (!user) throw new Error("User not found");
    return user;
  }

  async createUser(data) {
    return UserRepository.create(data);
  }
}

module.exports = new UserService();
