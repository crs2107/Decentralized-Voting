// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
contract Vote{
    address maker;
    struct candidate{
        string name;
        uint id;
        uint votes;
    }
    struct voter{
        address account;//Account Number of the voter
        uint number;//will count what is the sequential number of the perticular voter
        bool enq;//Enquire if the voter has already voted so that he/she cannot vote multiple times
        uint chk;//Will check if the voter is registaring (him/her)self twice or more and latter it will check if the voter is registered at all to vote
    }
    constructor(){
        maker=msg.sender;
        addCandidate("Bob");
        addCandidate("Allice");
    }
    event voteDone(
        address add,
        string name
    );
        event drawCandidate(
        uint indexed k
    );

    mapping(uint=>candidate) public Candidate;
    mapping(address=>voter) public Voter;

    //Function to add candidate

    uint number=0;
    function addCandidate(string memory _name) public returns(bool sucsess){
        require(maker==msg.sender);//Only the maker of the contract will be able to add Candidates
        Candidate[number]=candidate(_name,number,0);
        number++;
        return true;
    }
    //Function to see a candidate name by putting id

    function seeCandidate(uint _id) public view returns(string memory){
        if(_id<=number)
        return Candidate[_id].name;
        else
        return "Invalid Candidate Id";
    }
    //Function to add voter

    uint num=0;
    function addVoter(address _account) public returns(bool sucsess){
        require(msg.sender==_account);
        if(num>0){
        require(Voter[_account].chk==0);//Checing if the voter has registered before
        num++;
        Voter[_account]=voter(_account,num,false,1);
        }
        else{
        num++;
        Voter[_account]=voter(_account,num,false,1);
        }
        return true;
    }
    //Function to view voter

    function seeVoterId(address _add) public view returns(uint _id){
        return Voter[_add].number;
    }
    //Function to cast vote

    function voteCast(address _add,uint _id) public{
        require(Voter[_add].enq==false);//This will confirm the voter votes only once
        require(_id<=number);//This will check that the voter is not voting a real candidate
        require(Voter[_add].chk==1);//Check if the voter is at all registered
        Candidate[_id].votes++;
        Voter[_add].enq=true;
        emit voteDone(_add,Candidate[_id].name);
    }
    //Function to see number of votes of a given candidate

    function voteAtInstant(uint _id) public view returns(uint){
        return Candidate[_id].votes;
    }

    uint win_id;
    //Function that will compare votes and determine the id of winner

    function voteCounter() public{
    uint k;
    uint xy;
        for(k=0;k<=number;k++){
            if(xy<=Candidate[k].votes){
            xy=Candidate[k].votes;
            win_id=k;
            }
        }
    }


    //View the winner
    
    function winner() public view returns(string memory){

    //checking if there is a draw
    bool draw=false;
    uint k;
        for(k=0;k<=number;k++){
            if((k!=win_id) &&(Candidate[k].votes==Candidate[win_id].votes))
            {
                draw=true;
                break;
            }
        }
        if(!draw){
        return Candidate[win_id].name;
        }
        else{
            return 'Draw';
        }
    }
}
