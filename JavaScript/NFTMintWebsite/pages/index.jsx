import abi from '../utils/NaughtyHamsterNFT.json';
import whiteList from '../utils/whiteList.json';
import { ethers } from "ethers";
import Head from 'next/head'
import React, { useEffect, useState } from "react";
import styles from '../styles/Home.module.css'
const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')

export default function Home() {
    // Contract Address & ABI
    const contractAddress = "0x2Bc2Cbcd45E4CcecfD6D2998c80aaBD4485705F2";
    const contractABI = abi.abi;

    // Component state
    const [currentAccount, setCurrentAccount] = useState("");

    // Wallet connection logic
    const isWalletConnected = async () => {
        try {
            const { ethereum } = window;

            const accounts = await ethereum.request({ method: 'eth_accounts' })
            console.log("accounts: ", accounts);

            if (accounts.length > 0) {
                const account = accounts[0];
                console.log("wallet is connected! " + account);
            } else {
                console.log("make sure MetaMask is connected");
            }
        } catch (error) {
            console.log("error: ", error);
        }
    }

    // get merkletree
    const getMerkletreeFromWhiteList = async (whitelist) => {
        try {
            const leafNodes = whitelist.map(addr => keccak256(addr));
            const merkletree = new MerkleTree(leafNodes, keccak256, {sortPairs: true});
            return merkletree
        } catch (error) {
            console.log(error);
        }
    }

    function getDevProof(whitelist) {
        try {
            const leafNodes = whitelist.map(addr => keccak256(addr));
            const merkletree = new MerkleTree(leafNodes, keccak256, {sortPairs: true});
            const claimingAddr = keccak256(currentAccount)
            return merkletree.getHexProof(claimingAddr);
        } catch (error) {
            console.log(error);
        }
    }

    const connectWallet = async () => {
        try {
            const { ethereum } = window;

            if (!ethereum) {
                console.log("please install MetaMask");
            }

            const accounts = await ethereum.request({
                method: 'eth_requestAccounts'
            });

            setCurrentAccount(accounts[0]);
        } catch (error) {
            console.log(error);
        }
    }

    const devWhiteListMint = async () => {
        try {
          const {ethereum} = window;
    
          if (ethereum) {
            const provider = new ethers.providers.Web3Provider(ethereum, "any");
            const signer = provider.getSigner();
            const mintContract = new ethers.Contract(
              contractAddress,
              contractABI,
              signer
            );

            const proof = getDevProof(whiteList.dev)

            const whiteListMintTxn = await mintContract.whiteListMint(1, proof);
    
            await whiteListMintTxn.wait();
    
            console.log("dev mined ", whiteListMintTxn.hash);
    
            console.log("dev whiteListMint finished!");
          }
        } catch (error) {
          console.log(error);
        }
    };

    const normalWhiteListMint = async () => {
        try {
          const {ethereum} = window;
    
          if (ethereum) {
            const provider = new ethers.providers.Web3Provider(ethereum, "any");
            const signer = provider.getSigner();
            const mintContract = new ethers.Contract(
              contractAddress,
              contractABI,
              signer
            );

            const proof = getDevProof(whiteList.normal)

            const whiteListMintTxn = await mintContract.whiteListMint(1, proof);
    
            await whiteListMintTxn.wait();
    
            console.log("normal mined ", whiteListMintTxn.hash);
    
            console.log("normal whiteListMint finished!");
          }
        } catch (error) {
          console.log(error);
        }
    };

    const publicMint = async () => {
        try {
          const {ethereum} = window;
    
          if (ethereum) {
            const provider = new ethers.providers.Web3Provider(ethereum, "any");
            const signer = provider.getSigner();
            const mintContract = new ethers.Contract(
              contractAddress,
              contractABI,
              signer
            );

            const publicMintTxn = await mintContract.publicMint(1, {value: ethers.utils.parseEther("0.001")});
    
            await publicMintTxn.wait();
    
            console.log("public mined ", publicMintTxn.hash);
    
            console.log("publicMint finished!");
          }
        } catch (error) {
          console.log(error);
        }
    };

    useEffect(() => {
        isWalletConnected();

        return () => {}
    }, []);

    return (
        <div className={styles.container}>
            <Head>
                <title>NaughtyHamster Mint</title>
                <meta name="description" content="Tipping site" />
                <link rel="icon" href="/favicon.ico" />
            </Head>

            <main className={styles.main}>
                <h2 className={styles.title}>
                    NaughtyHamster Mint
                </h2>
                <br />

                {currentAccount ? (
                    <div>
                        <form>
                            <div>
                                <button
                                    type="button"
                                    onClick={devWhiteListMint}
                                >
                                    ???????????????mint
                                </button>
                            </div>
                            <br />

                            <div>
                                <button
                                    type="button"
                                    onClick={normalWhiteListMint}
                                >
                                    ???????????????mint
                                </button>
                            </div>  
                            <br />

                            <div>
                                <button
                                    type="button"
                                    onClick={publicMint}
                                >
                                    ??????mint(0.001ETH)
                                </button>
                            </div>       
                            <br />
                        </form>
                    </div>
                ) : (
                    <button onClick={connectWallet}> Connect your wallet </button>
                )}
            </main>
        </div>
    )
}
