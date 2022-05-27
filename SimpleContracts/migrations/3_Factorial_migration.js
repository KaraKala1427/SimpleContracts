const Factorial = artifacts.require("Factorial");

module.exports = function (deployer) {
  deployer.deploy(Factorial);
};
