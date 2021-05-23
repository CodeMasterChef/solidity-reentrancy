pragma solidity ^0.7.0;
contract EtherBank {
    uint public total = 0;
    mapping(address => uint) public balances;
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
         total += msg.value;
    }
    
    bool internal locked;
    
    modifier noReentrancy() {
        require(!locked , 'No reentrancy');
        locked = true;
        _;
        locked = false;
    }
    
    function withdraw(uint _amount) public noReentrancy {
        require(balances[msg.sender] >= _amount , "Out of amount");
        
        (bool sent, ) = msg.sender.call{value: _amount}("");
        
        require(sent, "Failed to send Ether");
        
        balances[msg.sender] -= _amount;
        total -= _amount;
        
    }
    
    function getBalance() public view returns(uint) {
        return balances[msg.sender];
    }
    
}
