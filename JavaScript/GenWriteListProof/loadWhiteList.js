const fs = require('fs');
const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')

const whiteList = require('./whiteList.json');

gen(whiteList.dev, "./devWhiteListProof.json");
gen(whiteList.normal, "./normalWhiteListProof.json");

function gen(whitelist, filePath) {
   var data = new Object();
   const leafNodes = whitelist.map(addr => keccak256(addr));
   const merkleTree = new MerkleTree(leafNodes, keccak256, {sortPairs: true});
   const rootHash = merkleTree.getRoot().toString('hex');
   data["rootHash"] = rootHash
   // console.log("rootHash is: ", rootHash);
   // console.log(merkletree.toString());
   var proofData = new Object();
   leafNodes.forEach((node, index) => {
      const hexProof = merkleTree.getHexProof(node);
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