var Crowdsource = artifacts.require("./Crowdsource.sol");
var NFT = artifacts.require("./NFT.sol");


module.exports = async function(deployer) {
  let crowdsource = deployer.deploy(Crowdsource);
  let nft = deployer.deploy(NFT);
  await Promise.all([crowdsource, nft]);
};
