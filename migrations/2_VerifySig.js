const VerifySig = artifacts.require("VerifySig");

module.exports = function (deployer) {
  deployer.deploy(VerifySig);
};
