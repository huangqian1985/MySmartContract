## solc 编译命令
### 生成abi

#### --base-path 库文件路径 

#### --abi 合约文件路径 

#### -o 生成abi文件路径 

```
solc --base-path "D:\work\BlockChain\DeployVerifyNFT\node_modules" --abi NaughtyHamster.sol -o abi
```



### 生成bin

#### --base-path 库文件路径 

#### --bin 合约文件路径 

#### -o 生成bin文件路径

```
solc --base-path "D:\work\BlockChain\DeployVerifyNFT\node_modules" --bin NaughtyHamster.sol -o bin
```



## abigen 生成命令

### 根据abi文件生成go绑定文件

#### --abi abi文件路径 

#### --bin bin文件路径 

#### --pkg 生成的go文件的包名 

#### --type go文件中的类型名称(和项目名称保持一致就好)

#### --out 输出的go文件路径

```
abigen --abi .\abi\NaughtyHamsterNFT.abi --bin .\bin\NaughtyHamsterNFT.bin -pkg main --type main --out NaughtyHamster.go
```

