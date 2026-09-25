const mongoose = require("mongoose");

const requiredEnvVars = [
  "MONGO_USERNAME",
  "MONGO_PASSWORD",
  "MONGO_HOST",
  "MONGO_PORT",
  "MONGO_DB",
];

for (const key of requiredEnvVars) {
  if (!process.env[key]) {
    console.error(`Missing required env var: ${key}`);
    process.exit(1);
  }
}

const { MONGO_USERNAME, MONGO_PASSWORD, MONGO_HOST, MONGO_PORT, MONGO_DB } =
  process.env;

const connectDB = async () => {
  try {
    await mongoose.connect(
      `mongodb://${MONGO_USERNAME}:${MONGO_PASSWORD}@${MONGO_HOST}:${MONGO_PORT}/${MONGO_DB}?authSource=admin`
    );
    console.log(`MongoDB connected on ${MONGO_HOST}:${MONGO_PORT}`);
  } catch (error) {
    console.error("MongoDB connection error:", error.message);
    process.exit(1);
  }
};

module.exports = connectDB;
