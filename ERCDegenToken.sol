
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Module4 is ERC20, Ownable{
 
    constructor() ERC20("Sisoncoin","SSC") Ownable(msg.sender){}


    // Mapping to track balances
    mapping(address => uint) public coinBalances;

    //Mint function
    function mintCoins(address to, uint amount) public onlyOwner {
        coinBalances[to] += amount;
    }
    //Burn function
    function burnCoins(address from, uint amount) public {
        require(coinBalances[from] >= amount, "Insufficient balance to burn");
        coinBalances[from] -= amount;
    }
    //Transfer function
    function transferCoins(address from, address recipient, uint amount) public {
        require(coinBalances[from] >= amount, "Insufficient balance to transfer");
        coinBalances[from] -= amount;
        coinBalances[recipient] += amount;
    }

    enum NFTType { MutantApe, RedactedRemilio, PudgyPenguin }

    mapping (address user => mapping( NFTType => uint StoredAmount)) public RedeemedNFT;

    event Redeemed(address indexed user, NFTType nftType, uint256 amount, uint256 cost, string message);

    function redeemCoins(address Address, NFTType nftType, uint256 amountofnft) external {
        require(amountofnft > 0, "Amount must be greater than zero");
        uint256 cost;
        if (nftType == NFTType.MutantApe) {
            cost = 100 * amountofnft; 
        } else if (nftType == NFTType.RedactedRemilio) {
            cost = 200 * amountofnft; 
        } else if (nftType == NFTType.PudgyPenguin) {
            cost = 300 * amountofnft; 
        } else {
            revert("Invalid NFT type");
        }
        require(coinBalances[Address] >= cost, "Insufficient balance");
        coinBalances[Address] -= cost;
        RedeemedNFT[Address][nftType] += amountofnft;
        emit Redeemed(Address, nftType, amountofnft, cost, "Redeem successful");
    }
}
