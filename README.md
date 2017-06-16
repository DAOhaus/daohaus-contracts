# Dao Haus Whitepaper
Managing shared assets through the formation of an DAO.  We will be focusing on the use case of a single residence in order to map the technical needs to an actual use -- however this is useful for many types of shared assets -- HOA organizations, a comunal lawn mower, a city pool, a corporation, or an entire national government.  

# Definitions
<code>The DAO</code>
The group of people that own voting rights within a group. Typically required to pay yearly taxes to be spent as proposals are received and approved.  

<code>Shared Asset</code>
For this particular use case shared asset will coorespond to a single family home residence.  Although if you have a active imagination, it can be subsituted for other assets types ;)

<code>Proposal</code>
A seperate contract that receives votes and tracks progress -- typically of a management task such as "fixing the leaky sink" or "replacing the roof".  A typical proposal contains the following:
>Chairman Fee:  How much work is this person going to need to put in to oversee this task, payable on completion of milestones.

>Proposal Cost: How much is going to be released to the chairman in order to pay for completion.

>Project Timeline:  A proposed length that this project should take including "milestones" which can be tied back to cost.

<code>Chairman</code>
In most cases this is the address that initialized a specific contract.  This responsibility typically denotes setting parameters for a proposal, receiving and distributing funds upon proposal success and can be transfered or voided via popular vote.  A special note should be made that iChairmen have temporary roles with definite purposes or a limited scope of responsibilities.  The initial creator of the token sale contract an example of this, whos role expires after successful funding of the contract.

<code>PVR - Popular Vote Ratio</code>
The ratio in which a proposal is deemed as accepted.  Popular or passing is 4/7ths approval of total votes cast.  Meaning if 7 total votes cast, needs at least 4 to be approval, but if 28 votes are cast, needs 16 approvals to be success.

<code> Registry Contract </code>
The contract where members send their token in order to vote.  In order to withdraw member must pass through a quite phase, be in good standing, and not be the Chairman on any outstanding proposals.  The Registry contract is also the enforcer of the law in selling off malicious member's tokens.


# Mechanisms
 
## Token Sale
The creation of The DAO is the initial step, and probably the most important for the longevity of the group.  It is important that the DAO's iChairman clearly communicate what the DAO forming will be centered around or the group will be so divided upon creation that nothing will get done.

> for example:  If the iChairman only advertises the DAO as a shared home ownership, the group may never actually gain a PVR on which home to buy because everyone wants it in a different city.  So the more specific the iChairman can be, the more unified and effective The DAO will be.

After success the iChairman should only have the amount of interest or involvement as their token percentage mandates. So none of the tokens will be reserved for the development team, and the iChairman should include a fee in the payment structure for orchastrating the creation for compensation.
 
Each token will be the same across ALL users, both as a symbol of ownership percentage and a right to vote.  Once a member is voted into special roles, it is kept in a registry on the contract itself. All functions executed will require a modifier to check for the presence of a token registered under the user in the registry contract. This is to say that while other people outside of token holders can take part in the organization and be appointed rights and responsibilities, only token holders can nominate, vote for, or remove such people from those positions. 

While the landscape of token sales is expanding, and new models are continually being developed and tested, here are a few characteristics to consider:
 
* Open vs Restrictive: Open meaning anyone can participate at any level (include whales).  Restrictive meaning to put limitations on things such as requiring an email confirmation of some sort and limit each confirmed addresses total amount possible to donate — Governments or other centralized organizations might want this, or just anyone trying to not want weird political factions from having automatic majority.
* Dutch Reverse Bid: Bid on how much are willing to pay for it starting from the top => https://en.wikipedia.org/wiki/Dutch_auction
https://blog.gnosis.pm/introducing-the-gnosis-token-launch-3cc4cffb5098
* Bancor => https://github.com/bancorprotocol/contracts/blob/master/solidity/contracts/CrowdsaleController.sol#L24
* Dollar cap: Say we’re selling X coins for X per coin. This is the common or default basic way.
* Token cap with bid (preferred): Set bottom price (similar to dollar cap) but allow for “bids” to occur rather than outright “sales”. Each new bid adds 1 additional day (maybe variable?) each time a new bid is placed… this is the mechanism that “penny bids” use, protects against “coil and pounce” to place bids right as auction ends. As soon as all tokens are claimed, they are not actually “sold” and higher bids replace the claim on a lower bid. If there is a pool of bids with exact same value, the tokens with the most recent bids are knocked off first, incentivizing people to be first mover. Could possibly be malicious with intent of never ending project. Chairman is appointed at beginning of contract to enable “close” when they feel a general consenSys has been reached, but must give 24 hour notification — this requires a solid “oracle notification system” like sms or email — possibly off block. This will typically be the team or developer hosting the token sale because they are incentivized to let it grow as high as possible. Other incentive to participants is to use “refer” addresses in metadata that allows for a share of “general” profits if tokens are bid above and beyond initial bid price for both buyer and referrer.
 
Note: If the community decides that they want to proceed in making their ownership legally co-ownership.  There first order of business that the newly minted members of this group would need to do is submit a proposal to actually buy the asset. Weather it is true co-ownership, or trusting an individual to be the sole owner, is up to each DAO respectively.  

## Registry Contract
The contract where members send their token in order to vote.  In order to withdraw member must pass through a quite phase, be in good standing, and not be the Chairman on any outstanding proposals.  The Registry contract is also the enforcer of the law in selling off malicious member's tokens.  Should include these public values:

> Popular Vote Ratio
> Yearly Tax
> Map of Token Holders => Balances

and these functions:

> Register:  Send 1 token and map's sent address as the registered member.
> Set Tax:  Executed w/ PVR, can change year to year depending
> Pay Tax:  Ether amount, marks user as being "paid up"
> Request Tax Amount: Return how much tax is owed for particular user
> Transfer:  Only to be executed with proof of PVR
> Withdraw:  Member withdraw's their token -- most likely to sell.  Must be offered to existing users first, before actual withdrawl takes place.
> Nominate Transfer: Member can nominate the forced transfer of a member's token.


## Voting dApp
This is probably the contract that will be used most.  It checks to see if the address that sends a vote has a token.  Some security feature will needed to be enabled that tokens can not be passed around only for voting functionality.  Perhaps if they are actively holding a vote in an open proposal, they are not allowed to withdraw. Also interesting to think about “proxy” voting and allowing someone else to control your vote.
 
It'd be nice to have the ability for other people to make suggestions on the existing proposal, like adding other options and have their vote transferred if they like newly presented ideas. Each proposal would need 2/3 approval of the voting members. Not to say 2/3 of ALL members, but of member that voted, 2/3 would need to be a yes. *Dash is very similar to this.
 
I imagine we would have different divisions of proposals. There would be “non-resource” type of proposals, like opinions or general consensus of rules - non enforceable type things, “tax” proposals or how to spend yearly contributions — would need the ability to tie $$$ and payout to a certain account, and “configuration” proposals that would change internal variables used in the contract.  These last two would take place on the "registry contract" -- *need to figure out how to technically de-couple the two, seems very limiting.
 
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
1. It get’s offered to existing users in an auction type system with a base cost.
2. Profits get spread throughout the group proportionally.
3. In case of "malicious" behavior and it doesn't get sold at auction, it is frozen on the contract and starts a "Dutch Reverse" type auction where each month it decreases in price until it is bought again.  New user must provide *identification to ensure it's not the bad actor just re-purchasing with another address.
 
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

