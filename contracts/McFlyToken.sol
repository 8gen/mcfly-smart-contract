pragma solidity ^0.4.15;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';


contract McFlyToken is MintableToken {

    string public constant name = 'McFly';
    string public constant symbol = 'MFL';
    uint8 public constant decimals = 18;

    mapping(address=>bool) whitelist;

    event Burn(address indexed from, uint256 value);
    event AllowTransfer(address from);

    modifier canTransfer() {
        require(mintingFinished || whitelist[msg.sender]);
        _;        
    }

    function allowTransfer(address from) onlyOwner {
        AllowTransfer(from);
        whitelist[from] = true;
    }

    function transferFrom(address from, address to, uint256 value) canTransfer returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function transfer(address to, uint256 value) canTransfer returns (bool) {
        return super.transfer(to, value);
    }

    function burn(address from) onlyOwner returns (bool) {
        Transfer(from, 0x0, balances[from]);
        Burn(from, balances[from]);

        balances[0x0] += balances[from];
        balances[from] = 0;
    }
}
