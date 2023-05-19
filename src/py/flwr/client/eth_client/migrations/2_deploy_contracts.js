var Crowdsource = artifacts.require("./Crowdsource.sol");


module.exports = async function(deployer) {
  let crowdsource = deployer.deploy(Crowdsource);
  await Promise.all([crowdsource]);
};
