import { NFTStorage } from 'nft.storage'
import { getFilesFromPath } from 'web3.storage'
import path from 'path'

const token = ''

async function main() {
  // you'll probably want more sophisticated argument parsing in a real app
  if (process.argv.length !== 3) {
    console.error(`usage: ${process.argv[0]} ${process.argv[1]} <directory-path>`)
  }
  const directoryPath = process.argv[2]
  var files = await getFilesFromPath(directoryPath)

  console.log(typeof directoryPath)
  console.log(files)

  const storage = new NFTStorage({ token })

  console.log(`storing file(s) from ${path}`)
  const cid = await storage.storeDirectory(files)
  console.log({ cid })

  const status = await storage.status(cid)
  console.log(status)
}
main()

// node storeDirectory.js D://test/