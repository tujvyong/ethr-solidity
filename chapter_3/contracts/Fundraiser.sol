// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Fundraiser is Ownable {
  using SafeMath for uint256;

  uint256 public totalDonations;
  uint256 public donationsCount;

  struct Donation {
    uint256 value;
    uint256 date;
  }
  // NOTE: mappingは列挙不可能、つまりkey=>valueのloopができない
  mapping(address => Donation[]) private _donations;

  // NOTE: indexedはEVMにおいてサブスクライバが自分に関係があるかも知れないイベントを絞りやすくなる。最大で３つのパラメータにつけれる
  // サブスクライバはイベント内の情報にアクセスできるが、スマコンの中からその情報にアクセスすることはできない
  event DonationReceived(address indexed donor, uint256 value);
  event Withdraw(uint256 amount);

  string public name;
  string public url;
  string public imageURL;
  string public description;
  address payable public beneficiary;

  constructor(
    string memory _name,
    string memory _url,
    string memory _imageURL,
    string memory _description,
    address payable _beneficiary,
    address _custodian
  ) public {
    name = _name;
    url = _url;
    imageURL = _imageURL;
    description = _description;
    beneficiary = _beneficiary;
    transferOwnership(_custodian);
  }

  function setBeneficiary(address payable _beneficiary) public onlyOwner {
    beneficiary = _beneficiary;
  }

  function myDonationsCount() public view returns (uint256) {
    return _donations[msg.sender].length;
  }

  function donate() public payable {
    Donation memory donation =
      Donation({ value: msg.value, date: block.timestamp });
    _donations[msg.sender].push(donation);
    // SafeMathのaddを使うことで、オーバーフロー対策できる。
    // https://github.com/OpenZeppelin/openzeppelin-contracts/issues/2465
    totalDonations = totalDonations.add(msg.value);
    donationsCount++;

    emit DonationReceived(msg.sender, msg.value);
  }

  // NOTE: ABIの制限により、外部関数・パブリック関数から構造体の配列を返すことはできない
  function myDonations()
    public
    view
    returns (uint256[] memory values, uint256[] memory dates)
  {
    uint256 count = myDonationsCount();
    values = new uint256[](count);
    dates = new uint256[](count);

    for (uint256 i = 0; i < count; i++) {
      Donation storage donation = _donations[msg.sender][i];
      values[i] = donation.value;
      dates[i] = donation.date;
    }

    return (values, dates);
  }

  function withdraw() public onlyOwner {
    // コントラクトの残高。コントラクトをアドレス型に変更してアクセスする
    uint256 balance = address(this).balance;
    beneficiary.transfer(balance);

    emit Withdraw(balance);
  }

  fallback() external payable {
    totalDonations = totalDonations.add(msg.value);
    donationsCount++;
  }
}
