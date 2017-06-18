# Dao Haus Whitepaper
Managing shared assets through the formation of an DAO.  We will be focusing on the use case of a single residence in order to map the technical needs to an actual use -- however this is useful for many types of shared assets -- HOA organizations, a comunal lawn mower, a city pool, a corporation, or an entire national government.  

# Definitions
<code>The DAO</code>
The group of people that own voting rights within a group. Typically required to pay yearly taxes to be spent as proposals are received and approved.

<code>Shared Asset</code>
For this particular use case shared asset will coorespond to a single family home residence.  Although if you have a active imagination, it can be subsituted for other assets types ;)

<code>Member</code>  
Someone that has registerd as a member by sending their token to the Registery Contract -- allowing participation in voting and message boards.

<code>Silent Member</code>  
Someone that has not registered as a member, but holds a token.  Usually this is someone that either wants to sell their interest in the DAO and Shared Asset.  Is immune from a proposal to force withdraw them from the DAO that is typically reserved for malicous members.

<code>Non Resource Proposal Contract </code>
A very open ended contract that is used to set "rules" or change variables on the registry contract itself.  It's an internal governance tool that is part technical (for changing of variables) and part societal in setting common rules that can be referenced by the group when electing to force withdraw someone from the DAO.

<code>Resource Proposal Contract</code>
A seperate contract that has set parameters that need to be met in order for proposal to be successful and the transfer of funds to the specified proposal chairman. Contains Description of the propsal, relays votes and tracks progress -- typically of a management task such as "fixing the leaky sink" or "replacing the roof".

<code>Chairman</code>
In most cases this is the address that initialized a specific contract.  This responsibility typically denotes setting parameters for a proposal, receiving and distributing funds upon proposal success and can be transfered or voided via popular vote.  A special note should be made that iChairmen have temporary roles with definite purposes or a limited scope of responsibilities.  The initial creator of the token sale contract an example of this, whos role expires after successful funding of the contract.

<code>PVR - Popular Vote Ratio</code>
The ratio in which a proposal is deemed as accepted.  Popular or passing is 4/7ths approval of total votes cast.  Meaning if 7 total votes cast, needs at least 4 to be approval, but if 28 votes are cast, needs 16 approvals to be success.

<code> Registry Contract </code>
The contract where members send their token in order to vote.  In order to withdraw member must pass through a quite phase, be in good standing, and not be the Chairman on any outstanding proposals.  The Registry contract is also the enforcer of the law in selling off malicious member's tokens.


# Mechanisms
 
## Token Sale Contract
The creation of The DAO is the initial step, and probably the most important for the longevity of the group.  It is important that the DAO's iChairman clearly communicate what the DAO forming will be centered around or the group will could be divided upon creation and nothing will get done.

> for example:  If the iChairman only advertises the DAO as a shared home ownership, the group may never actually gain a PVR on which home to buy because everyone wants it in a different city.  So the more specific the iChairman can be in attracting members, the more unified and effective The DAO will be.

After success the iChairman should only have the amount of interest or involvement as their token percentage mandates. So none of the tokens will be reserved for the development team, and the iChairman should include a fee in the payment structure for orchastrating the creation for compensation.
 
Each token will be the same across ALL users, both as a symbol of ownership percentage and a right to vote.  Once a member is voted into special roles.  All functions executed will require a modifier to check for the presence of a token registered in the registry contract. This is to say that their token will be frozen while voting on any proposal.  Also this implies that other people outside of token holders can take part in the organization and be appointed rights and responsibilities, but only token holders can nominate, vote for, or remove such people from those positions. 

While the landscape of token sales is expanding, and new models are continually being developed and tested, here are a few characteristics to consider to a token sale:
 
> **Open vs Restrictive:** Open meaning anyone can participate at any level (include whales).  Restrictive meaning to put limitations on things such as requiring an identification confirmation of some sort (uport) and limit each confirmed addresses total amount possible to donate — Anyone trying to not want weird political factions from having automatic majority, because essentially 1 individual could own 75% of the tokens and practically own the entire asset.

> **Dutch Reverse Bid:** Bid on how much are willing to pay for it starting from the top => https://en.wikipedia.org/wiki/Dutch_auction
https://blog.gnosis.pm/introducing-the-gnosis-token-launch-3cc4cffb5098

> **Bancor:**  https://github.com/bancorprotocol/contracts/blob/master/solidity/contracts/CrowdsaleController.sol#L24

> **Dollar cap:** Say we’re selling X coins for X per coin. This is the common or default basic way.

> **Token cap with bid (preferred):** Set bottom price (similar to dollar cap) but allow for “bids” to occur rather than outright “sales”. Each new bid adds 1 additional day (maybe variable?) each time a new bid is placed… this is the mechanism that “penny bids” use, protects against “coil and pounce” to place bids right as auction ends. As soon as all tokens are claimed, they are not actually “sold” and higher bids replace the claim on a lower bid. If there is a pool of bids with exact same value, the tokens with the most recent bids are knocked off first, incentivizing people to be first mover. To counteract the possibility of a never ending project, the Chairman is appointed on launch to enable “close” when they feel a general consensus has been reached, but must give 24 hour notification — this requires a solid “oracle notification system” (* See "Questions" section below) like sms or email — possibly off block. This will typically be the team or developer hosting the token sale because they are incentivized to let it grow as high as possible. 
 
Note: If the community decides that they want to proceed in making their ownership legally co-ownership.  There first order of business that the newly minted members of this group would need to do is submit a proposal to actually buy the asset. Weather it is true co-ownership, or trusting an individual to be the sole owner, is up to each DAO respectively.  

## Registry Contract
The contract where members send their token in order to vote.  In order to withdraw member must pass through a quite phase, be in good standing, and not be the Chairman on any outstanding proposals.  The Registry contract is also the enforcer of the law in selling off malicious member's tokens.  Should include these public values:

> Popular Vote Ratio

> Yearly Tax

> Maximum Number of Proposals (* see "Questions" secion below)

> Map of Token Holders => Balances

and these functions:

> **Register Member:**  Send 1 token and map's sent address as the registered member.

> **Register Proposal:** Proposals need to register with the Registry Contract in order for it to check that an address is not involved in any outstanding proposals or suspensions before withdrawl.

> **Set Vote:**  Each proposal that is registered needs to have a "record vote" function that broadcasts the vote to the registry contract nested or associated with it's parent proposal contract identifier. ** _still need to explore this further.  Biggest question is for a proposal to execute, it will either have to send ALL the data at once for the registry contract to verify the addresses against it's user mapping, or one at a time as the votes come it.  This function assumes we'll do it as the votes come in_

> **Archive Proposal:**  Because the registry contract will be holding votes associated with each proposal we could keep everything there, but think it might be cleaner and easier to allow it to clear it's memory, push a "summary" to the individual contract, and just have a pointer to it for record keeping purposes

> **Set Proxy:**  Set's another token holder's address as the proxy

> **Set Tax:**  Executed w/ PVR, can change year to year depending

> **Pay Tax:**  Ether amount, marks user as being "paid up"

> **Request Tax Amount:** Return how much tax is owed for particular user

> **Force Transfer:** Executed from proposal in which user's vote a member Only to be executed with proof of PVR

> **Withdraw:**  Member withdraw's their token -- most likely to sell on secondary market.  Must be offered to existing users first, before actual withdrawl takes place.

> **Nominate Transfer:** Member can nominate the forced transfer of a member's token.


## Proposal Contract
This is probably the contract that will be used most.  It checks to see if the address that sends a vote has their token listed on the Registry Contract.  Some security feature will needed to be enabled that tokens can not be passed around only for voting functionality.  Perhaps if they are actively holding a vote in an open proposal, they are not allowed to withdraw. Also interesting to think about “proxy” voting and allowing someone else to control your vote.
 
It'd be nice to have the ability for other people to make suggestions on the existing proposal, like adding other options and have their vote transferred if they like newly presented ideas. Each proposal would need 2/3 approval of the voting members. Not to say 2/3 of ALL members, but of member that voted, 2/3 would need to be a yes. *Dash is very similar to this.
 
I imagine we would have different divisions of proposals. There would be:

* “non-resource” type of proposals, like opinions or general consensus of rules - non enforceable type things. 
* “resource” proposals or how to spend yearly contributions — would need the ability to tie Ether and payout to a certain account -- votes would most likely be relayed onto the parent registry contract *need to figure out how to technically de-couple the two, seems very limiting.  A typical resource proposal contains the following:
> **Chairman Fee:**  How much work is this person going to need to put in to oversee this task, payable on completion of milestones.

> **Proposal Cost:** How much is going to be released to the chairman in order to pay for completion.

> **Project Timeline:**  A proposed length that this project should take including "milestones" which can be tied back to cost.
 
## Member Management
Voting would be used in this aspect, but perhaps in a different UI or in a different section of app because it feels like a separate concern. Probably have different rules, ratios, and variables associated. Also be sure to read the section on “Secondary Market” because anyone pushed out by members would most likely just default to that process as if they voluntarily entered into it.
 
With this there would be no chairperson or moderator. As little as 1 person could nominate someone that should be voted “off the island” so to speak. They would then need 10% of the DAO to confirm or “second” the nomination to kick a someone out. The person in question would have a character limit of 2,000 words in which to defend themselves, and each member would have a 500 word area vouch for or against the member in question and allows links to other places online.
 
Members could change their vote after casting, in light of new information coming forth, and a 1 month time allotment would be enforced and a member couldn't be brought up to be “voted off” again for 1 year. Maybe all member management questions would be at the same time yearly?... Incentivize people “cool off” and wait before just wanting to kick someone off, but possibly would need the ability to do an “emergency” removal for particularly bad behavior.
 
Special consideration should probably be given to members that are in “CHAIRMAN” positions. For instance if they have submitted a proposal for a group resource allocation “tax”, it’s timeline and all voting is put on hold. Nothing would stop another member from proposing the same objective if the matter was urgent.
 
## Member Communication
Chat and community forum, notification system. Probably want to allow this to also integrate into the voting app to allow people to vote directly from their sms or email messages. Is this technically possible to integrate SMTP protocol into ethereum natively? Or would we just use a trusted and reliable 3rd party? 
 
We need to send updates for whenever a member has been nominated for removal, a new tax proposal submitted, or other community issues. Probably nice to let people set notification settings, but some things could not be opted out of — like tax proposals.
 
## Marketing
Incentivize members to share with others. They get some sort of multiplier if shared. Also important to communicate that the token sale price is not based solely in the underlying asset, but in the experience, the community, the efficiency. Basically the value in going to Harvard is not based solely in the building and facilities… it’s the network and community you’re introduced to.
 
>Build In Functionality
>Disolve
>Mint More Tokens
 
 
## Secondary Market
If somebody doesn’t pay taxes they are kicked out of the group. How can that be redeemed or transferred to someone else?
1. It get’s offered to existing users in an auction type system with a starting cost of what was paid for the last auctioned token with member having the ability to undercut to allow for a minimum cost.  Profits go to owner.
2. If base cost is not met, and owner is in good conditions, can withdraw the token and become a silet member.
3. In case of "malicious" behavior and it doesn't get sold at auction, it is frozen on the contract and starts a "Dutch Reverse" type auction where each month it decreases in price until it is bought again.  New user must provide *identification to ensure it's not the bad actor just re-purchasing with another address. *_See "Questions" section at bottom_
 
## Project Management:
Each proposal submitted would have a chairman (default sender), but could be altered with approval of group. Chairman is responsible for funds that are sent to his address (or if vendor has eth address then that is the preferred method) and chairman can upload updates, video and photo links to show progress.
 
For projects, might need a way to tie it to a proportionate currency. Like if the group agrees that taxes for the next year should be $100 per person… need a way so that people know they need to send .12 ether or .5 ether depending on price fluctuation. ——— or possibly that doesn’t matter? Do we trust the proposal of the project to only withdraw what they need for the project then send the rest back? Along the “tax” stream, if the price skyrockets or drops, at the end of the year they have the ability to “refund” leftover taxes to the shareholders. Or at anytime during the year they can propose to raise more money for whatever reason.
 
## Scheduling app:
Proportionate to holdings, you have different windows of time that are open to scheduling your uses. Scheduling is an ongoing process, with no blackout dates except for construction or other allotted dates approved through a proposal.
 
Each day becomes available 1 year in the future. The first year, with AirBNB scheduling becoming available 6 months in advance.  See the section on Rental Opportunity to find more information about rental management. 
 
 Each token you hold represents an entire night from 12pm till 12pm the next day.  Locks on the door make a query each day for who it allows to use its location.  Holders of that day can manually add “approved" addresses that can access. That way you can gift your “token use” to friends or family, but ultimately you are responsible for their behavior and only you have voting rights.  
 
Upon arrival the member should fulfill a checklist making sure specific things are in order and alright.  If they fail to do so, they will be held accountable for whatever things are already broken that they did not record.
 
If something's not right with the condition of the house they file a “proposal” - either to cover it with community funds or to fine the previous member directly. This goes through the designated process.  If a “direct member” is fined they have a process very similar to the “nomination of removal” process.  If that is resolved, and member does not pay within 1 month their token is automatically sent through the secondary market in order to pay for damages they incurred. Obviously a proposal can be raised to direct funds towards a further lawsuit on behalf of the DAO - or can be pursued privately if damages are significant.
 
## Rental Opportunity:
Although the primary goal of the house is not as a dedicated rental property, it seems prudent to allow for it to gain its highest economic use while not being used.  An online portal that integrates into the designated smart contract would need to be created for a renter to schedule for an unused day as well as pay Eth and submit their address that should be allowed to open doors.
 
# Questions:
* Does something exist that performs eth => email or eth => sms notification system.
* Can we assign specific id numbers to specific tokens?  Making "double votes" impossible by voting, then transfering token to new address that then votes and continues the pattern?
* How to tie oracle into contract.  Can contracts make API calls and store value?  Like "current market of Eth"
* How to tie the registry contract to individual and seperate voting contracts.  It's like multi-sig... but how would that work exactly because you'd need the results of one contract to trigger event on a seperate contract.  I think if the proposal contract knew the address of the registry contract from the beginning, then on "success" it would actually just pass all the addresses of 'for' and 'against' to the registry contract that then would actually execute the tax payout to the chairman designated on the proposal... Does this sound right?
* 4. Some of these would be nice to have looping functionality.  I know this is frowned upon for gas consumption. Could we set maximum numbers of things like proposals?  That way we know it won't get over like 10 or something and can do controlled loops?
* Identification verification.  Is uport good enough for something like this?  What are other strategies to ensure identity of new members in other DAO structures.

