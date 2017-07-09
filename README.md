# Dao Haus Whitepaper
Managing shared assets through the formation of an DAO.  We will be focusing on the use case of a single residence in order to map the technical needs to an actual use -- however this is useful for many types of shared assets -- HOA organizations, a comunal lawn mower, a city pool, a corporation, or an entire national government. 

This is a work in progress, and much of the time just coppied over from a quip document so formating is probably off if reading this on github, but all the substance is still here.

## Definitions & Vernacular

**The DAO:**
The group of people that own voting rights within a group. Typically required to pay yearly taxes to be spent as proposals are received and approved.

**Shared Asset:**
For this particular use case shared asset will correspond to a single family home residence. Although if you have a active imagination, it can be substituted for other assets types ;)

**Member:** 
Someone that has registered as a member by sending their token to the Registry Contract -- allowing participation in voting and message boards.

**Silent Member:**
Someone that has not registered as a member, but holds a token. Usually this is someone that either wants to sell their interest in the DAO and Shared Asset. Is immune from a proposal to force withdraw them from the DAO that is typically reserved for malicious members.

**Registrar Contract:**
 The contract where members send their token in order to vote. In order to withdraw member must pass through a quite phase, be in good standing, and not be the Chairman on any outstanding proposals. The Registry contract is also the enforcer of the law in selling off malicious member's tokens.

**Non Resource Proposal Contract:**
 A very open ended contract that is used to set "rules" or change variables on the registry contract itself. It's an internal governance tool that is part technical (for changing of variables) and part societal in setting common rules that can be referenced by the group when electing to force withdraw someone from the DAO.

**Resource Proposal Contract:**
A separate contract that has set parameters that need to be met in order for proposal to be successful and the transfer of funds to the specified proposal chairman. Contains Description of the proposal, relays votes and tracks progress -- typically of a management task such as "fixing the leaky sink" or "replacing the roof".

**Member Management Contract:**
The contract in which people nominate others to be “force withdrawn” in cases where the member has been malicious or unsavory to the other members for whatever reason.

**Chairman:**
In most cases this is the address that initialized a specific contract. This responsibility typically denotes setting parameters for a proposal, receiving and distributing funds upon proposal success and can be transferred or voided via popular vote. A special note should be made that iChairmen have temporary roles with definite purposes or a limited scope of responsibilities. The initial creator of the token sale contract an example of this, who's role expires after successful funding of the contract.

**PVR - Popular Vote Ratio:**
The ratio in which a proposal is deemed as accepted. Popular or passing is 4/7ths approval of total votes cast. Meaning if 7 total votes cast, needs at least 4 to be approval, but if 28 votes are cast, needs 16 approvals to be success.

**v2 -- Proxy Member:** 
Someone that has been extended the ability to control the token from a different address than from who the token is registered on the Registry Contract.  This will be a nice feature to have but not part of version 1.



## Contracts



Token Sale Contract

The creation of The DAO is the initial step, and probably the most important for the longevity of the group. It is important that the DAO's iChairman clearly communicate what the DAO forming will be centered around or the group will could be divided upon creation and nothing will get done.

for example: If the iChairman only advertises the DAO as a shared home ownership, the group may never actually gain a PVR (popular vote ratio) on which home to buy because everyone wants it in a different city. So the more specific the iChairman can be in attracting members, the more unified and effective The DAO will be.

Also important to communicate that the token sale price is not based solely in the underlying asset, but in the experience, the community, the efficiency of the group. Basically the value in going to Harvard is not based solely in the building, course work, and text books… it’s the network and community you’re introduced to — so although the house might only be worth physically $500,000 - it sells for a $750,000 because everyone likes the group and people want in for social or other reasons.

After a successful funding the iChairman should only have the amount of interest or involvement as their token percentage mandates. This means none of the tokens will be reserved for the development team, and the iChairman should include a fee in the payment structure for orchestrating the creation for compensation.

Each token will be the same across ALL users, both as a symbol of ownership percentage and a right to vote proportionately.  This token is not absolutely necessary to hold a position such as chairman, as that role can be specified on creation by whoever is publishing the contract.  However, only token holders can nominate, vote for, or remove such people from those positions.

While the landscape of token sales is expanding, and new models are continually being developed and tested, here are a few characteristics and models to consider such as: 

**Open Vs Restrictive:**
Open meaning anyone can participate at any level (include whales). Restrictive meaning to put limitations on things such as requiring an identification confirmation of some sort (uport) and limit each confirmed addresses total amount possible to donate — Anyone trying to not want weird political factions from having automatic majority, because essentially 1 individual could own 75% of the tokens and practically own the entire asset.

**Dutch Reverse Auction:**
Bid on how much are willing to pay for it starting from the top
https://en.wikipedia.org/wiki/Dutch_auction 
https://blog.gnosis.pm/introducing-the-gnosis-token-launch-3cc4cffb5098

**Bancor:**
This is a general idea where there is a minimum amount of time available, with a hidden cap and fixed price.
https://cointelegraph.com/news/bancor-an-innovative-token-sale
https://github.com/bancorprotocol/contracts/blob/master/solidity/contracts/CrowdsaleController.sol#L24

**EOS:**
https://steemit.com/eos/@eosio/draft-eos-token-sale-smart-contract

All that being said, I couldn't help but to dip my toes into the strategy waters of token launch strategy based on fixed token amounts which is as follows.

**Fixed Token Quantity Bid:**
Set bottom price (similar to dollar cap) but allow for “bids” to occur rather than outright “sales”. 

Each new bid adds 1 additional day (or other variable) each time a new bid is placed… this is the mechanism that “penny bids” use, protects against “coil and pounce” to place bids right as auction ends.

As soon as all tokens are claimed, they are not actually “sold” and higher bids replace the claim on a lower bid. If there is a pool of bids with exact same value, the tokens with the most recent bids are knocked off first, incentivizing people to be first mover.

To counteract the possibility of a never ending project, the Chairman is appointed on launch to enable the contract to execute or close when they feel a general consensus has been reached, but must give 24 hour notification — this requires a solid “oracle notification system” (* See "Questions" section below) like sms or email — possibly off block. This will typically be the team or developer hosting the token sale because they are incentivized to let it grow as high as possible without trolls making it last forever.

It's variables and functions are: 

* **Minimum Price:**  The initial price of each token
* **Active:**  Default to true, false when iChairman signals close.
* **Total Supply:**  Initial supply of tokens, in this case 365
* **Maximum Ownership Share: ** The maximum amount that any one address can bid on.  This is to prevent against attackers that through purchasing 3/4 of the tokens, now effectively control the asset as if they owned 100% of it.
* **Token Array:**  representational array of all 365 tokens.  Custom schema to keep track of which address is currently highest bidder, their bid, and the timestamp of when they bid (for FILO calculations).

**Withdraw Chairman Fee:** Sends predetermined amount to chairman.  Could be a set fee, a percentage, or really any payment schedule that would want to be created.

**Check Eligibility:** if public, this automatically passes.  If private, checks to make sure the sender meets defined requirements.  In this case it will be if they have been added to the “white list” after verifying their number or possibly just verifying with uport.

**Bid:** Takes 3 parameters, first is how many tokens they are bidding on and second what they're bid is, third is their contact info (email and/or phone #).  Checks to make sure amount is equal to or more than the minimum price.  Records the order of the bid (for use in FILO incase higher bids come in) as well as checks that this wouldn't put them over the top established by the maximum ownership share value. 

**Execute Sale:** Registers tokens and their percentages with the Registrar Contract.  Sends the chairman fee to the chairman, and set's the remainder onto the registrar contract in order to be used as seen fit by the members.

**Signal Close: **Allows chairman to signal that sale will close in 24 hours, believes a consensus has been reached on price of tokens.  Set's active to false.

**Refund: **Allows chairman to refund certain addresses should a problem arise.

**Set Deadline: **Called each time a successful bid goes through.  Modifier looking to see if still active.



Registrar Contract

The contract where members send their token in order to vote, as well as their “taxes” in order to be used towards proposed projects.  In order to withdraw their tokens, a member must pass through a quite phase, be in good standing, and not be the Chairman on any outstanding proposals. The Registry contract is also the enforcer of the law in selling off malicious member's tokens when a member management contract is executed. 

Taxing is done on an annual basis per token owned.  Taxes need to be paid before the taxation date.  If not paid user receives a notification warning them that they are at risk of being forced to withdraw, and then on that date any delinquent addresses are force transferred and the proceeds go into the Registrar Contract to cover taxes.

The reason that the default tax date is at the end of the year is to allow for changes to the tax throughout the year as volatility dictates.  If taxes run out because of falling prices, users must propose to change taxes higher, and everyone has till the end of the year to comply.  In the other direction, if prices soar then a proposal can be drafted to redistribute taxes back to their owners proportionate to their token holdings. 

It's variables and functions are: 

* **Popular Vote Ratio:** ratio needed for a vote to pass
* **Yearly Tax:** How many ether each member is expected to pay yearly in order to maintain their token
* **Taxation date:** What day tax is due yearly, default to Dec 31st.
* **Tax Balance:** Tax available to use towards resource project or be refunded back to members
* **Available Tax Balance:** Tax balance minus any outstanding proposal's costs that might get passed.  This is used when a new proposal registers in order to check that there are sufficient funds to achieve it.
* **Resource Proposal Length:** How long proposals should be available to stay proposals until are no longer eligible for votes.
* **Member Withdrawal Length:**  How long member management proposals should be available to stay open for votes.  Also pauses the timeline for any resource proposals that are outstanding that have the member in question as the chairman.  (This prevents attacks from occurring where 1 week before the deadline, person likes the resource proposal vote and nominates to remove the chairman, essentially blocking any new votes from being cast and the outcome is prematurely secured)
* **Member Withdrawal Frequency:** How long between member being nominated to force withdraw.  This is to prevent attacker from repeatedly requesting that a chairman be removed, hence putting their proposal on hold and blocking there proposals from ever being voted on.  Default set to once a year.
* **Quite Phase Length:** How long a member must wait in order to withdraw their tokens to ensure they don't commit a “hit and run” against the DAO
* **Secondary Market Decrease Rate:** The rate in Wei that the token listed on the exchange is depreciated each day in order to find a buyer.
* **Maximum Number of Proposals:** The overall number of proposals is naturally restricted by how much Ether is in the tax balance, because the total of proposed funds to be used can't be more than what is available in the tax balance.  However, this would protect against if a malicious member sends a thousand proposals at 0 ether, in order to flood the space with “distraction” proposals in order to sneak something by (* see "Questions" section below)
* **Map: **Addresses => Balances
* **Token Array: **Finalized token array from the token sale.  Needed for secondary market info when forcing a withdrawal.
* **Amendments:**  This is a mapping of rules that act as a type of “constitution”.  However, these are unenforceable by the contract itself and are here for the purpose that other's read to align their vision together, or have common understandings of what will cause a member to be nominated to for a force withdrawal.  It's up the the members themselves to read them and take them into consideration, essentially each member becoming a member of the “supreme court” and interpreting the articles as they are written in cases where a member is being forced to withdraw. 
* **v2 — whitelist of approved tokens:**  Can be basic, like via proof of phone number - but some identification check in order to verify each person controls their own tokens.  Is “version 2” at this point because simple solutions can be gamed fairly easily, and complex solutions are not readily known to me, or accessible.
* **v2 — mint more tokens:**  Incase somehow the asset can be divided into smaller parts — ie they add a mother in law studio that can act as it's own unit, but is still tied to the underlying assets and was paid for with the DAOs resources, determining how to create new tokens, how to differentiate their value and privileges seems beyond the scope of this initial project.

**Register Members:** Limited to being called only by the token sale contract.  Map's sent address as the registered member and set's appropriate token amount to however much they've bid.  Also sets info on the token array.  

**Register Force Withdrawal:** Receives the address of the member in question - pauses the contracts that they happen to be chairman of.

**Register Proposal:** Proposals need to register with the Registry Contract in order for the Registry Contract to check that an address in question is not chairman  or involved in any outstanding force withdrawal proposals before withdrawal.  Also starts the timer for when it will accept votes and opinions.

**Check Eligibility: ** Sent from a proposal contract, this checks to see if the address casting a vote is indeed registered to this DAO.  ** Some thought has been given to if all votes should just be held on this contract itself or on the proposal contract, I'm still not sure of the technical merits of either approach, but going ahead with the assumption that all will be stored on the proposal.

**Archive Contract:** Because the registry contract will be checking votes associated with each proposal we could keep everything there indefinitely, but think it might be cleaner and easier to allow it to clear it's memory, push a "summary" to the individual contract, noting weather it passed or failed with the corresponding votes and just have a pointer to it for record keeping purposes.  This would be triggered after an execution.

**Execute Proposal Contract**: Would check to make sure call is coming from a registered proposal. Would request information such as chairman, and the proposal cost and distribute the funds from the “tax account” as specified

**Set Rule:** Executed w/ PVR from a non-resource contract, can change as often as a new proposal is passed.  Changes any and all of the variables listed above such as PVR, Yearly Tax, Maximum # of proposals, etc...

**Set Amendment:** Executed w/ PVR from a non-resource contract, can change as often as a new proposal is passed.  Changes any and all of the amendments (listed by number) — and allows for creation of a new one if number is not found. (possibly could be same as above set rule if contracts can dynamically add public variables)

**Pay Tax:** Ether amount, records the amount paid for that calendar year for that user.

**Distribute Tax:** Takes the yes / no votes, and the amount to be distributed.  Must be executed from a resource contract to re-distribute some amount of Ether back to the token holders proportionate to their holdings.

**Check for Delinquent Addresses:** Checks 1 month prior to taxation date... how can you do timed functions... like solidity equivalent to setTimeout()

**Request Tax Amount:** Takes an address, return how much tax is owed for particular user.  True is returned if paid in full, amount is returned if have withstanding balance.

**Force Withdrawal:** Called from the registered member management contract, sending with the “yes” and “no” votes (addresses) creating a Marketplace Contract to sell. 

**Withdrawal:** Member transfers ownership to another address -- most likely to sell on secondary market. Must first pass a “quite period” to ensure member is not performing a “hit and run”.  Is just a waiting period for the typical ERC20 spec transfer function.

**v2 — Set Proxy:** Set's another token holder's address as the proxy.  Any amount of proxies can be given.  You can give a proxy out to your son, daughter, cousin, neighbor, etc... allowing them to act on your behalf.  It's important that proxies can vote independently on different proposals.




Non Resource Proposal Contract

This proposal is the most basic of the proposals, but allows for variables and amendments on the Registrar Contract to be changed.

It's variables and functions are: 

* **Status: **Set to “true” if passing, “false” if failing.  (Maybe this should be codes, to denote multiple states such as “passing but still has time”, “passed”, “failing but still has time”, “failing”, “paused via force withdrawal”, “killed”, etc... depending on multiple factors.
* **Registry Contract Address:** The address of it's parent Registrar Contract.  For security checks, and knowing where to send commands to change rules / amendments.
* **Chairman address:** The ability for whoever publishes the proposal to set a chairman, it's by default the person that submitted the proposal, but this allows only for someone to be responsible to kill contract.
* **Map of Addresses** => Opinions
* **Map of Addresses** => Votes
* **Active:  **Default is set to true, flipped to false when contract is executed.  A modifier is present on all functions that doesn't allow them to be run if is not active.
* **Variable to Change: **Name of the variable to change 
* **Amendment to Change: **# of the amendment to change.
* **Value: **New value to be set to the variable / amendment in question.

**Init**:  Registers itself with the Registrar Contract

**Cast Vote**:  Can take parameters of “yes”, “no”, or “withdraw” —  Checks to make sure the address that sent the vote is registered.  Then maps it to either “yes” or “no” options multiplied by how many tokens the sender has in the registry — or withdraws their vote completely. You have the ability to change before contract is executed by sending another transaction.  Their address is then public, which is used to validate to make sure they can't withdraw their escrow

**Add Opinion**:  Checks to make sure the address that sent the opinion is registered.  Then maps it to the user's address.  If Only way to change it is to send a completely new transaction.  The message will completely override what your current opinion is.  Takes a parameter to point to a duplicate contract if they want to propose something similar but slightly different.

**Get Opinions**:  Returns opinions, most likely to show on a UI, or gauge how heated or opinionated people are on this particular thing.

**Kill Proposal**:  Only executable by it's parent registry contract or the chairman.  Incase of a chairman being voted to force withdraw by the other members, it would nullify all proposals they have in question.

**Execute Proposal**:  Sends the votes to the registry contract to be “archived” as a record of who voted for what.  If PVR is met then sets the new value to the public variable in question



Resource Proposal Contract

This is probably the contract that will be used most.  It needs to be tied to a parent “registry” contract in order to pull resources from it, and in order to ensure the participants have registered their tokens on it.  It will ensure proposals comply with it's parent's rules such as the determined PVR.

If someone likes a proposal but wants to make one small adjustment they can “duplicate” the proposal and pass along the variables they want to change, however the timeline will stay the same and will close along with it's parent.

It's variables and functions are: 


* **Chairman Fee:** How much work is this person going to need to put in to oversee this task, payable on completion of milestones.
* **Status: **Set to “true” if passing, “false” if failing.  (Maybe this should be codes, to denote multiple states such as “passing but still has time”, “passed”, “failing but still has time”, “failing”, “paused via force withdrawal”, “killed”, etc... depending on multiple factors.
* **Parent Contract:** The contract that was duplicated to create this particular contract.
* **Is Dependent on Parent:**  Regardless of if it passes PVR, will only pass as long as parent also passes.
* **Proposal Cost:** How much is going to be released to the chairman in order to pay for completion.
* **Registry Contract Address:** The address of the Registry Contract is at.  For security check reasons.
* **Chairman address:** The ability for whoever publishes the proposal to set a chairman, it's by default the person that submitted the proposal, but this allows for people to nominate others into positions of power.  Also allows array of addresses incase this is being used to redistribute taxes to all members.  In which case, paid out according to their portion of owned tokens.
* **Map of Addresses** => Opinions
* **Map of Addresses** => Votes
* **Active:  **Default is set to true, flipped to false when contract is executed.  A modifier is present on all functions that doesn't allow them to be run if is not active.
* **v2 — Project Timeline:** A proposed length that this project should take.  Initially thought of breaking 1 project into multiple milestones and breaking the tax payout accordingly, but think that it should be done proposal by proposal.  For instance, one proposal might be to get an architect to draw up plans for a deck.  After that proposal is finished, and there is a solid understanding of cost based off the drawings, then a NEW proposal would be submitted for construction.  This is instead of having 1 proposal for the entire project.
    
    This could *POSSIBLY* be used in the future to penalize the chairman going forward if they don't meet the timeline.  For now just as a marker for transparency so everyone voting can gauge how long it'll take.  Or for people to point to as “proof”

**Init**:  Registers itself with the Registrar Contract

**Cast Vote**:  Can take parameters of “yes”, “no”, or “withdraw” —  Checks to make sure the address that sent the vote is registered.  Then maps it to either “yes” or “no” options multiplied by how many tokens the sender has in the registry — or withdraws their vote completely. You have the ability to change before contract is executed by sending another transaction.  Their address is then public, which is used to validate to make sure they can't withdraw their escrow

**Add Opinion**:  Checks to make sure the address that sent the opinion is registered.  Then maps it to the user's address.  If Only way to change it is to send a completely new transaction.  The message will completely override what your current opinion is.  Takes a parameter to point to a duplicate contract if they want to propose something similar but slightly different.

**Get Opinions**:  Returns opinions, most likely to show on a UI, or gauge how heated or opinionated people are on this particular thing.

**Kill Proposal**:  Only executable by it's parent registry contract or the chairman.  Incase of a chairman being voted to force withdraw by the other members, it would nullify all proposals they have in question.

**Execute Proposal**:  Sends the votes to the registry contract to be “archived” as a record of who voted for what.  If PVR is met then sends the amount specified to the chairman specified in the contract.

**Duplicate / Add-on Proposal**:  Duplicate enables a person to copy the contract info and variables, (minus the votes & opinions) — and make any changes you want to it.  Leaves a pointer back to the parent, so that people can view similar contracts as viable options, or as possible additions.

Duplicates of duplicates are not allowed, and there is nothing stopping a parent from being passed successfully along with it's child.  They could both be valid proposals, and in some cases could be “amendments” or “add ons” to the original proposal.

**I'm tempted to allow the group to change proposal variables such as who the chairman is, the registry contract, chairman fee, etc... but I feel like creating a NEW contract is a better route, because the truly important things (votes & opinions) need to start from scratch anyways.




Member Management Contract

This contract behaves very similar to how the resource contracts work.  However, there would be no chairperson, and they would not be “duplicateable” as the resource contracts are.  

As little as 1 person could nominate someone that should be voted “off the island” so to speak. They would then need to meet the PVR of members confirming or 'yes' voting the nomination to kick a someone out. The person in question would have a character limit of 2,000 words in which to defend themselves, and each member would have a 500 word area vouch for or against the member in question and allows links to other places online.

It's variables and functions are:

* **Registry Contract Address:** The address of the Registry Contract is at.  For security check reasons.
* **Member to Withdraw:** The address of whoever they are wanting to force withdraw from the DAO.
* **Accusation:** The 2000 character reason that they are wanting the member to be force withdrawn 
* **Good Standing Fee:** When specified, the member to withdraw can pay the amount required (to go into Registrar Contract) and the contract is then killed.  If set to false, then member can not pay their way out.
* **Map of Addresses** => Opinions (500 character limit)
* **Map of Addresses **=> Votes
* **Active:  **Default is set to true, flipped to false when contract is executed.  A modifier is present on all functions that doesn't allow them to be run if is not active.

**Init**:  Registers itself with the Registrar Contract

**Cast Vote**:  Can take parameters of “yes”, “no”, or “withdraw” —  Checks to make sure the address that sent the vote is registered.  Then maps it to either “yes” or “no” options multiplied by how many tokens the sender has in the registry — or withdraws their vote completely. You have the ability to change before contract is executed by sending another transaction.  Their address is then public, which is used to validate to make sure they can't withdraw their escrow

**Add Opinion**:  Checks to make sure the address that sent the opinion is registered.  Then maps it to the user's address.  If Only way to change it is to send a completely new transaction.  The message will completely override what your current opinion is.  Takes a parameter to point to a duplicate contract if they want to propose something similar but slightly different.

**Get Opinions**:  Returns opinions, most likely to show on a UI, or gauge how heated or opinionated people are on this particular thing.

**Execute Proposal**:  Sends the votes to the registry contract to be “archived” as a record of who voted for what.  If PVR is met then sends the amount specified to the chairman specified in the contract.

**Pay Fee**: receives payments and when Good Standing Fee is reached, kills the contract.

*note: I've removed the ability for the chairman to “kill proposal” because want to eliminate desire to artificially nominate someone to withdraw in hopes that they will “pay off” or bribe or blackmail or whatever.  Want to try to avoid anything that might not make these sincere.


Secondary Market Contract

If somebody doesn’t pay taxes or breaks fundamental rules of the DAO they are kicked out.  This contract sets fair rules for compensation and auctioning their token.  First it's important to understand that users can be kicked out for two reasons: 

1. On principal — broke rules, or loss of favor in the group — in which they should be compensated for their token at whatever the sale price is.
2. Because of Money — didn't pay taxes, or have Nomination of Force Withdrawal held against them in which they could resolve if they paid a Good Standing Fee. — in which case the sale goes to compensate first the Good Standing Fee, and then are compensated with whatever is left over (if anything)

The contract receives the address in question, checks the amount that was paid for it originally (recorded on the Registrar Contract) and starts the bid there.  It then has 5 days in order to receive a bid and treat it the same as in the original token sale with whoever nominated the force withdrawal acting as the iChairman.

The iChairman does have a few responsibilities with this sale, so to compensate he get's 2% fee for initiating the process, verifying that the new person and is responsible to close the auction incase of trolling.

But if 5 days passes and nobody bids (for some reason the token has lost value) it starts a reverse dutch auction, decreasing price by the determined Secondary Market Decrease Rate each day until it becomes 0 and waits for someone to claim it.

Independent of if the member has 1 token or 10 tokens, all are offered up when a force withdrawal occurs, and the bid must be for the entire lot.  When a bid is won, the forced member's address is replaced on the Registrar Contract with the winning bidder's address.

It's variables and functions are:

* **Price:**  The initial price per token, is re-calculated each time a bid occurs
* **Active:**  Default to true, false when chairman signals close.
* **Deadline: **Date the sale started
* **Good Standing Fee Needed: **Fee needed in order to self-destruct the contract
* **Chairman Fee:**  Percentage that is given to the iChairman as compensation for nomination, watching for “trolls”, and executing the contract.

**Init:** No need to registers itself with the Registrar Contract, because it was instantiated by it, so already knows the address, the fee needed, etc.  Just set's the “Deadline” in order to indicate the line between fixed token bid sale and reverse dutch auction.

**Bid:** Takes 2 parameters, what they're bid is and second is a means for communication.  Checks to make sure amount is equal to or more than the price and acts accordingly (if past the 5 day mark then calculates what the price should be by retrieving the “**Secondary Market Decrease Rate”** and multiplying it by the days, and rewards instantly)

**Execute Contract:** Only accessibly to the iChairman.  His responsibility is to verify that the new address owner is not like the wife of the forced out user that is bidding on behalf of the forced out member.  This could easily be thwarted, so I question putting it in at all, but figure I might as well make a note of it for the iChairman. On execution the contract sends the chairman fee, and signals to the Registrar Contract to transfer the token.  

**Signal Close: **Allows chairman to signal that sale will close in 24 hours, believes a consensus has been reached on price of tokens.  Set's active to false.

**Set Deadline: **Called each time a successful bid goes through.  Modifier looking to see if it's pass that day in order to start reverse dutch auction rather than fixed token style bid..



Scheduling & Rental Contract:

Proportionate to holdings, you have different windows of time that are open to scheduling your uses. Scheduling is an ongoing process, with no blackout dates except for construction or other allotted dates approved through a proposal.
Each day becomes available 1 year in the future. The first year, with AirBNB scheduling becoming available 6 months in advance. See the section on Rental Opportunity to find more information about rental management.

Each token you hold represents an entire night from 12pm till 12pm the next day. Locks on the door make a query each day for who it allows to use its location. Holders of that day can manually add “approved" addresses that can access. That way you can gift your “token use” to friends or family, but ultimately you are responsible for their behavior and only you have voting rights.

Upon arrival the member should fulfill a checklist making sure specific things are in order and alright. If they fail to do so, they will be held accountable for whatever things are already broken that they did not record.

If something's not right with the condition of the house they file a “proposal” - either to cover it with community funds or to fine the previous member directly. This goes through the designated process. If a “direct member” is fined they have a process very similar to the “nomination of removal” process. If that is resolved, and member does not pay within 1 month their token is automatically sent through the secondary market in order to pay for damages they incurred. Obviously a proposal can be raised to direct funds towards a further lawsuit on behalf of the DAO - or can be pursued privately if damages are significant.

Rental Opportunity:

Although the primary goal of the house is not as a dedicated rental property, it seems prudent to allow for it to gain its highest economic use while not being used. An online portal that integrates into the designated smart contract would need to be created for a renter to schedule for an unused day as well as pay Eth and submit their address that should be allowed to open doors.


## v2 — Future Functionality Ideas

**Marketing:** 
Incentivize members to share with others during the token sale. They get some sort of multiplier if include data in their bid transaction that points to a user that also wins a bid.  

**Stable Coin:**
This project is begging for some sort of stable coin, but for now just depends on the group self managing the money by raising Ether taxes when needed, and re-distributing taxes back to token holders when exists excess. 

**Member Communication:**
Chat and community forum, notification system.  This should be done off chain but would be nice to verify that they have a token in order to participate.  Most likely the “chat” functionality is just something like slack.  Only conversations that are relevant to the contract are ones that go along with opinions for official blockchain voting.

One thing that does seem necessary is to allow notifications, because a member shouldn't be visiting the contract daily.  Rather things should be running smoothly and a member should receive an email / sms saying “New Proposal Submitted” with the details right there in the email.  If the member responds “yes” or “no” it casts the vote as such.  Is this technically possible to integrate SMTP protocol into ethereum natively? Or would we just use a trusted and reliable 3rd party? Can contracts make API calls?

Even if we had a simplistic approach — we could possibly have a “log” that logs out each kind of transaction, and an off chain site that is watching for changes and notifying users independently.

Actions that should trigger notification:

* New proposal submitted (resource, non-resource, and member management)
* Proposal timeline near finishing (reminder to vote) 
* Proposal finished with results
* Token(s) available on secondary market
* Tax due (with 1 month warning before expiration)
* *Optional* new votes, opinions
* *Optional* Token sale triggered for ending (24 hour notice)
* *Optional* Token sale bid has been outbid
* *Optional* Asset is rented and receiving your portion of proceeds

Questions:

* Does something exist that performs eth => email or eth => sms notification system.
* How to tie an oracle into a contract?  Is this just a trusted 3rd party contract? Can contracts make API calls? Like "current market of Eth" from some API?
* In my registrar contract I have a function to change contract variables, and then a second to add to an array of “amendments” — I could combine these if it's technically possible to create new public variables after a contract has been deployed.  Possible?  Or should I stick with an array?
* Possible to do “setTimeout()” like functions in solidity.  Put something on a schedule?  Or does everything need to be user initiated? (example of checking delinquent accounts for taxes on a yearly schedule)

* Is it correct to assume that the Registrar Contract would technically be the “owner” of all the tokens held in it?  And it would use the Token Array variable to keep track of who owned how many and at what price etc...  I guess I could have a second function almost identical to the ERC20 spec mapping(address => uint256) balances; but instead of true ownership (in which case the contract owns them) it would be a proxy mapping of how many are appropriated to which addresses.  Is that right? (example of the “register members” and Do I need to be thinking about Bancor? Ox? Other exchange type things?)

* As long as state isn't being changed (like just checking weather it exists or not) then isn't looping fine right?  Some of my planned functions would benefit from looping functionality. If it still consumes gas... thoughts on setting maximum lengths of things like proposals or members (http://solidity.readthedocs.io/en/develop/types.html#arrays)? That way we know the gas cost or something and can do controlled loops?  Or 
* Code example of a contract deploying another contract?  Is this a good idea or is there a better pattern? (for use in token sale, after a token sale is complete, should the contract itself create the new Registrar Contract?  or should the Registrar Contract already be created with just a pointer to the Registrar Contract's address) — the second is most likely needed if wanting to do “whitelist” for authenticated addresses that can participate in not only the token sale, but in the secondary market as well after the token sale is over and done with.

* Identification verification. Is uport good enough for something like this? What are other strategies to ensure identity of new members in other DAO structures.  I'm thinking of doing a two part verification.  Once in order to become “white listed” for protected groups — for instance to insure someone doesn't buy 2/3 or the initial offering and practically owns it from there without having to actually own the entire thing.  My thoughts for a secure process are in two steps:
    
    1.  Pre-sale: In order to get white listed just allow them to send picture holding ID to some centralized DB, automatically adds address to list.
    
    2.  Post-sale: in order to withdraw they must actually have a video convo with chairman.  After convo they are added to a verified list, and the tokens can be withdrawn.
    
    I put the harder of the two verifications after the sale, in order to not put up blockers to the actual token launch.  This all feels.... like wrong.  What's the best way to do authentication to prevent people becoming automatic wales?  Do I put in something robust?  Or just a simple like “verify phone number” type system like this one: https://www.proofofphone.com/ (https://www.proofofphone.com/and) and just know that if someone wants to spoof it and game the system they can.
    
* Event listener / logger.  I sometimes feel the need to log every transaction, or allow people to set “notifications” to get notified for everything, or nothing.  But I'd like to log each change or each vote.... is there something that does something similar?  Perhaps just a modifier? Gas cost considerations?
* v2 — proxy — i'm not wanting to tackle this at the moment, but you might have already put thought into it and am curious what you think.  My **Main Question is:** How can we make it so the registry contract holds the token needed for voting — Making "double votes" impossible by voting — while still allowing them to transfer or “proxy” their token to another “non” token holding account for use of the asset.  (Donate a night's use to a nephew for example) — 
    
    I See two possible solutions, which are dependent on how the asset get's used.  If it's as simple as an arbitrary “code” used to gain access into the asset then the token holder can schedule it, and the contract will give the key code for the lock to open with.  The member can then send that code to their nephew without risk of exposing any of their account information or sending any token at all.  However, if the lock requires an actual transaction to be broadcast at the physical location... there will need to be a different mechanism involved.

Research:

* I don't quite understand how to make a general purpose coin for the entire network that would back all this up and be interchangeable.  I should read the Aragon white paper, but I feel like you might have better ideas, so wanted to pick your brain on how you imagine it for Boardroom.  
* I'm really wanting to know more about small groups that have setup their own governance.  Obviously the original roman / greek models come to mind but want more recent examples.  This is usually along lines of religious groups in the 1800s, but I'd really like to stay away from religious groups, but that's all that comes to mind right now like the:
    
    -- historical --
    Romans: https://en.wikipedia.org/wiki/Roman_Republic
    Greek: https://en.wikipedia.org/wiki/Greece
    
    -- more modern -- 
    Mormons: https://en.wikipedia.org/wiki/State_of_Deseret
    Quakers: https://en.wikipedia.org/wiki/Quakers
    Hutterites: https://en.wikipedia.org/wiki/Hutterite — interesting practice of forcing all members of group into leadership positions, so that they understand what it entails and sympathize with current leaders because they too have been in their shoes, however, could have bad results if incompetent.

