var Crowdsource = artifacts.require("./Crowdsource.sol");
var Token = artifacts.require("./Token.sol");
var NFT = artifacts.require("./NFT.sol");


module.exports = async function(deployer) {
  let crowdsource = deployer.deploy(Crowdsource);
  let token = deployer.deploy(Token);
  let nft = deployer.deploy(NFT);
  await Promise.all([crowdsource, token, nft]);
};
