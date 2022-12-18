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

  // Mapping from token ID to parent IDs
  mapping(uint256 => (uint256, uint256)) public parentIds;

  // Mapping from address to boolean indicating whether an address is a registered breeder
  mapping(address => bool) public registeredBreeders;

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

  // Function to register a new breeder
  function registerBreeder(address breeder) public {
    require(!registeredBreeders[breeder], "Breeder is already registered");
    registeredBreeders[breeder] = true;
  }

  // Function
function declareAnimal(uint256 _tokenId, string memory _uri) public {
  require(_tokenId != 0, "Cannot declare an animal with ID zero");
  require(tokenOwner[_tokenId] == msg.sender, "Sender does not own the animal");
  require(tokenURIs[_tokenId] == "", "Animal has already been declared");

  tokenURIs[_tokenId] = _uri;
}

// Function to mint a new token and assign it to an owner
function mint(address _to, uint256 _tokenId, string memory _uri, uint256 _motherId, uint256 _fatherId) public {
  require(_to != address(0), "Cannot mint to the zero address");
  require(_tokenId != 0, "Cannot mint a token with ID zero");
  require(tokenOwner[_tokenId] == address(0), "Token with ID already exists");

  // Only allow registered breeders to mint new animals
  require(registeredBreeders[msg.sender], "Sender is not a registered breeder");

  // Set the owner, URI, and parent IDs of the new animal
  tokenOwner[_tokenId] = _to;
  tokenURIs[_tokenId] = _uri;
  parentIds[_tokenId] = (_motherId, _fatherId);

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
  return tokenUR
// Function to declare the parents of an animal when creating it
function declareAnimalWithParents(uint256 _tokenId, string memory _uri, uint256 _motherId, uint256 _fatherId) public {
  mint(_tokenId, _uri, _motherId, _fatherId);
}

// Function to retrieve the parent IDs of an animal
function getParents(uint256 _tokenId) public view returns (uint256, uint256) {
  return parentIds[_tokenId];
}

// Add a new function to test the declare animal function
function testDeclareAnimal(uint256 _tokenId, string memory _uri, address evaluator) public {
  // Declare the animal
  declareAnimal(_tokenId, _uri);

  // Call ex4_testDeclareAnimal to receive points
  evaluator.ex4_testDeclareAnimal(_tokenId);
}

// Add a new function to allow breeders to declare dead animals
function declareDeadAnimal(uint256 _tokenId) public {
  require(_tokenId != 0, "Cannot declare an animal with ID zero");
  require(tokenOwner[_tokenId] == msg.sender, "Sender does not own the animal");

  // Set the URI of the animal to an empty string to indicate that it is dead
  tokenURIs[_tokenId] = "";
}

// Add a new function to test the declare dead animal function
function testDeclareDeadAnimal(uint256 _tokenId, address evaluator) public {
  // Declare the animal as dead
  declareDeadAnimal(_tokenId);

  // Call ex5_declareDeadAnimal to receive points
  evaluator.ex5_declareDeadAnimal(_tokenId);
}


