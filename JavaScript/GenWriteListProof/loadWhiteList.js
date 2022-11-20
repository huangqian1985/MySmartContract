const fs = require('fs');
const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')

const whiteList = require('./whiteList.json');

gen(whiteList.dev, "./devWhiteListProof.json");
gen(whiteList.normal, "./normalWhiteListProof.json");

function gen(whitelist, filePath) {
   var data = new Object();
   const leafNodes = whitelist.map(addr => keccak256(addr));
   const merkletree = new MerkleTree(leafNodes, keccak256, {sortPairs: true});
   const rootHash = merkletree.getRoot().toString('hex');
   data["rootHash"] = rootHash
   // console.log("rootHash is: ", rootHash);
   // console.log(merkletree.toString());
   var proofData = new Object();
   leafNodes.forEach((node, index) => {
      const hexProof = merkletree.getHexProof(node);
      proofData[whitelist[index]] = hexProof;
      // console.log(whitelist[index], hexProof);
   });
   data["proof"] = proofData

   fs.writeFile(filePath, JSON.stringify(data, null, 2), (error) => {
      if (error) {
         console.log('An error has occurred ', error);
         return;
      }
      console.log('Data written successfully to disk');
   });
}

genMyProof(whiteList.dev, "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4")
genMyProof(whiteList.dev, "0x5B38Da6a701c568545dCfcB03FcB875f56beddC3")

function genMyProof(whitelist, myAddr) {
   const leafNodes = whitelist.map(addr => keccak256(addr));
   const merkletree = new MerkleTree(leafNodes, keccak256, {sortPairs: true});
   const rootHash = merkletree.getRoot().toString('hex');
   const claimingAddr = keccak256(myAddr)
   const hexProof = merkletree.getHexProof(claimingAddr);
   // 校验proof
   console.log("Addr:" + myAddr + ", 是否在白名单中:" + merkletree.verify(hexProof, claimingAddr, rootHash))
}