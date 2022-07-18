const MintNFT = artifacts.require("MintNFT");

module.exports = function (deployer) {
  deployer.deploy(MintNFT);
};
