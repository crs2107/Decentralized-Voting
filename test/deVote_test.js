const Vote = artifacts.require("Vote");

let vote = null;
before(async () => {
  vote = await Vote.new();
});
contract("Vote", (accounts) => {
  describe("Adding of Candidates and Voters", async () => {
    it("Should check for right candidates", async () => {
      await vote.addCandidate("Raju");
      let x = await vote.seeCandidate(1);
      assert.equal(x, "Allice");
    });
    it("Checks the Voter Id of an added voter", async () => {
      await vote.addVoter(accounts[1],{from:accounts[1]});
      await vote.addVoter(accounts[5],{from:accounts[5]});
      let y = await vote.seeVoterId(accounts[5]);
      assert.equal(y, 2);
    });
  });
  describe("Checking the casting of a vote", async () => {
    it("Checks if a vote is been casted to the right candidate ", async () => {
      await vote.addVoter(accounts[2],{from:accounts[2]});
      await vote.voteCast(accounts[1], 1);
      await vote.voteCast(accounts[2], 0);
      await vote.voteCast(accounts[5], 1);
      let z= await vote.voteAtInstant(1);
      await assert.equal(z, 2);
    });
});
describe("Checking a Winner", async () => {
    it("Checks winner when there is no draw ", async () => {
        await vote.voteCounter();
        let q=await vote.winner();
        await assert.equal(q, 'Allice');
    });
    it("Checks winner when there is a Draw ", async () => {
        await vote.addVoter(accounts[3],{from:accounts[3]});
        await vote.voteCast(accounts[3], 0);
        await vote.voteCounter();
        let s=await vote.winner();
        await assert.equal(s, 'Draw');
      });
  });
});

