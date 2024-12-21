// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedStudentLoan {
    struct Loan {
        string studentName;
        uint256 loanAmount;
        bool isApproved;
        bool isRepaid;
    }

    address public admin;
    mapping(address => Loan) public loans;

    constructor() {
        admin = msg.sender;
    }

    // Request a loan
    function requestLoan(string memory _studentName, uint256 _loanAmount) public {
        require(loans[msg.sender].loanAmount == 0, "Loan already requested");
        loans[msg.sender] = Loan(_studentName, _loanAmount, false, false);
    }

    // Approve a loan by the admin
    function approveLoan(address _studentAddress) public {
        require(msg.sender == admin, "Only admin can approve loans");
        require(loans[_studentAddress].loanAmount > 0, "No loan request found");
        loans[_studentAddress].isApproved = true;
    }

    // Repay the loan
    function repayLoan() public payable {
        Loan storage loan = loans[msg.sender];
        require(loan.isApproved, "Loan is not approved");
        require(!loan.isRepaid, "Loan already repaid");
        require(msg.value == loan.loanAmount, "Repayment amount does not match loan amount");

        loan.isRepaid = true;
    }

    // Fetch loan details
    function getLoanDetails(address _studentAddress)
        public
        view
        returns (string memory, uint256, bool, bool)
    {
        Loan memory loan = loans[_studentAddress];
        return (loan.studentName, loan.loanAmount, loan.isApproved, loan.isRepaid);
    }
}
