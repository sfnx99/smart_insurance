// SPDX-License-Identifier: CC-BY-NC-4.0

pragma solidity >=0.8.2 <0.9.0;

enum Status {
    ACTIVE,
    PAID,
    LAPSED,
    CANCELLED
}

contract InsuranceContract {

    address private immutable provider;
    address private immutable customer;
    uint256 private immutable payout;
    uint256 private immutable premium;
    Status private status;

    // this must be called by a smart contract factory
    constructor(address Provider, address Customer, uint256 Premium) payable {

        // call an API route to determine the payout
        uint256 payout_multiple = 10;

        provider = Provider;
        customer = Customer;

        payout = Premium * payout_multiple;
        // assert provider has funds

        premium = Premium;
        require(msg.value >= premium, "Insufficient premium funding");

        status = Status.ACTIVE;
    }

    // calls an API route to check for catastrophy
    function actionPayout() public requireProvider {
        (bool success, ) = customer.call{value: payout + premium}("");
        require(success, "Transfer to customer failed");
        // notify provider
        status = Status.PAID;
    }

    modifier requireProvider {
        require(msg.sender == provider);
        _;
    }

    function viewStatus() public view returns(Status) {
        return status;
    }
}
