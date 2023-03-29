// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8; //version of solidity

contract SimpleStorage {
    
    uint256 favoriteNumber;
    People public person = People ({favoriteNumber:2 , name:'Pac'});
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    mapping(string => uint256) public nametoFavoriteno;


    People[] public people;

    function addperson(string memory _name , uint256 _favoriteNumber) public{
        People memory newperson = People({favoriteNumber: _favoriteNumber , name : _name});
        people.push(newperson);

        nametoFavoriteno[_name]=_favoriteNumber;
    }


    function store(uint256 fav) public{
        favoriteNumber = fav;
    }

    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }
    
}

//0xd9145CCE52D386f254917e481eB44e9943F39138
