pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

// We use OpenZeppelin's SafeERC721 contract to ensure that our ERC721 implementation is secure
contract MyERC721 is SafeERC721 {
  using SafeMath for uint256;

  string public name;
  string public symbol;
  uint8 public decimals;

  // Mapping from token ID to owner
  mapping(uint256 => address) public tokenOwner;

  // Mapping from token ID to URI
  mapping(uint256 => string) public tokenURIs;

  // Event for when a token is transferred
  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );

  constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }

  // Function to mint a new token and assign it to an owner
  function mint(address _to, uint256 _tokenId, string memory _uri) public {
    require(_to != address(0), "Cannot mint to the zero address");
    require(_tokenId != 0, "Cannot mint a token with ID zero");
    require(tokenOwner[_tokenId] == address(0), "Token with ID already exists");

    tokenOwner[_tokenId] = _to;
    tokenURIs[_tokenId] = _uri;

    emit Transfer(address(0), _to, _tokenId);
  }

  // Function to transfer a token from one owner to another
  function transferFrom(address _from, address _to, uint256 _tokenId) public {
    require(_from != address(0), "Cannot transfer from the zero address");
    require(_to != address(0), "Cannot transfer to the zero address");
    require(_tokenId != 0, "Cannot transfer a token with ID zero");
    require(tokenOwner[_tokenId] == _from, "Sender does not own the token");
    require(_to != tokenOwner[_tokenId], "Token is already owned by the recipient");

    tokenOwner[_tokenId] = _to;

    emit Transfer(_from, _to, _tokenId);
  }

  // Function to retrieve the owner of a token
  function ownerOf(uint256 _tokenId) public view returns (address) {
    return tokenOwner[_tokenId];
  }

  // Function to retrieve the URI of a token
  function tokenURI(uint256 _tokenId) public view returns (string memory) {
    return tokenURIs[_tokenId];
  }
}
