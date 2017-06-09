# Dao Haus Whitepaper
Managing shared assets through the formation of an DAO.  While this is useful for many types of shared assets -- a comunal lawn mower, community pool, a corporation, or an entire national government -- we will be focusing on the use case of a single residence in order to map the technical needs to an actual use.  

>**Use Case:**
>I want to create a contract or series of contracts that enables the democratic management of a house. A DAO HAUS if you will. Ownership in the house is divided into tokens that represent right of use per year at 365 tokens.The following are the different aspects that would need to be incorporated:
 
## Token Sale
Whoever puts together a deal should be rewarded but after initial sale in some way, but they should only have the amount of interest or involvement as their token percentage mandates. So none of the tokens will be reserved for the development team.

Only people with a token have voting rights. I've heard this model referenced in RAC (AdXChain for example) -- however it's probably important to figure out if tokens have metadata associated with them (ie this particular token is a chairman, or has particular rights / responsibility - this token allows user to -- incase of a multi unit house -- stay in unit 1 while another token is required to stay in unit 2)
 
However I'm leaning more towards the token being the same across ALL users, as a symbol of interest and a right to vote.  Once a member is voted into special roles, it is kept in a registry on the contract itself. All functions executed just require the presence of a token.  Meaning that while other people outside of the token holders can take part in the organization and be appointed rights and responsibilities, but only token holders can nominate, vote for, or remove such people from those positions. 
 
* Open vs Selective: anyone can participate at any level (include whales) or put restrictions on things, like requiring an email confirmation of some sort and limit each confirmed addresses total amount possible to donate — Governments or other centralized organizations might want this, or just anyone trying to not want weird political factions from having automatic majority.
* Dutch: Bid on how much are willing to pay for it starting from the top => https://en.wikipedia.org/wiki/Dutch_auction
* Dollar cap: Say we’re selling X coins for X per coin. This is the common or default way
* Token cap with bid (preferred): Set bottom price (similar to dollar cap) but allow for “bids” to occur rather than outright “sales”. Each new bid adds 1 additional day (maybe variable?) each time a new bid is placed… this is the mechanism that “penny bids” use, protects against “coil and pounce” to place bids right as auction ends. As soon as all tokens are claimed, they are not actually “sold” and higher bids replace the claim on a lower bid. If there is a pool of bids with exact same value, the tokens with the most recent bids are knocked off first, incentivizing people to be first mover. Could possibly be malicious with intent of never ending project. Chairman is appointed at beginning of contract to enable “close” when they feel a general consenSys has been reached, but must give 24 hour notification — this requires a solid “oracle notification system” like sms or email — possibly off block. This will typically be the team or developer hosting the token sale because they are incentivized to let it grow as high as possible. Other incentive to participants is to use “refer” addresses in metadata that allows for a share of “general” profits if tokens are bid above and beyond initial bid price for both buyer and referrer.
 
Note: If the community decides that they want to proceed the way of making it a legal entity.  There first order of business that the newly minted members of this group would need to do is elect a chairman.  The chairman - that is responsible for forming the real life legal entity responsible for owning the shared asset.  *See section on member management and voting for how to set chairman. 
 
## Voting App
This is probably the most important aspect of the contract.  It checks to see if the address that sends a vote has a token.  Some security feature will needed to be enabled that tokens can not be passed around only for voting functionality.  So with each address, each token should most likely also have a ID or Hash number that gets recorded on each vote etc… Also interesting to think about “proxy” voting and allowing someone else to control you vote.
 
 It will be pivotal for management of the group. The primary use would be in voting to allow for appropriation of “taxes” each year to go towards certain projects. Voting to raise taxes, lower taxes, etc.
 
It'd be nice to have the ability for other people to make suggestions on the existing proposal, like adding other options and have their vote transferred if they like newly presented ideas. Each proposal would need 2/3 approval of the voting members. Not to say 2/3 of ALL members, but of member that voted, 2/3 would need to be a yes. *Dash is very similar to this.
 
I imagine we would have different divisions of proposals. There would be “non-resource” type of proposals, like opinions or general consensus of rules - non enforceable type things, “tax” proposals or how to spend yearly contributions — would need the ability to tie $$$ and payout to a certain account, and “configuration” proposals that would change internal variables used in the contract. For example currently the ratio set forth to gain approval is 2/3 — but say some members decided this was dumb, so they wanted only a 55% aspect ratio to pass (which obviously would require a 2/3 ratio to pass, but after it would be enacted)
 
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
 
Build In Functionality
Disolve
Mint More Token
 
 
## Secondary Market
If somebody doesn’t pay taxes they are kicked out of the group. How can that be redeemed or transferred to someone else?
1. It get’s offered to existing users at a fixed cost
2. Profits get spread throughout the group proportionally
3. Possibly get sent to an auction system within the group for an entire year. After a year then they are just “abandoned”
 
## Project Management:
Each proposal submitted would have a chairman (default sender), but could be altered with approval of group. Chairman is responsible for funds that are sent to his address (or if vendor has eth address then that is the preferred method) and chairman can upload updates, video and photo links.
 
The chairman would need to specify the following things in his proposal:
Chairman fee:  How much work is this person going to need to put in to oversee this task
Project cost: How much is going to be released to the chairman in order to pay.
Project timeline:  If 
 
For projects, might need a way to tie it to a proportionate currency. Like if the group agrees that taxes for the next year should be $100 per person… need a way so that people know they need to send .12 ether or .5 ether depending on price fluctuation. ——— or possibly that doesn’t matter? Do we trust the proposal of the project to only withdraw what they need for the project then send the rest back? Along the “tax” stream, if the price skyrockets or drops, at the end of the year they have the ability to “refund” leftover taxes to the shareholders. Or at anytime during the year they can propose to raise more money for whatever reason.
 
## Scheduling app:
Proportionate to holdings, you have different windows of time that are open to scheduling your uses. Scheduling is an ongoing process, with no blackout dates except for construction or other allotted dates approved through a proposal.
 
Each day becomes available 1 year in the future. The first year, with AirBNB scheduling becoming available 6 months in advance.  See the section on Rental Opportunity to find more information about rental management. 
 
 Each token you hold represents an entire night from 12pm till 12pm the next day.  Locks on the door make a query each day for who it allows to use its location.  Holders of that day can manually add “approved" addresses that can access. That way you can gift your “token use” to friends or family, but ultimately you are responsible for their behavior and only you have voting rights.  
 
Upon arrival the member should fulfill a checklist making sure specific things are in order and alright.  If they fail to do so, they will be held accountable for whatever things are already broken that they did not record.
 
If something's not right with the condition of the house they file a “proposal” - either to cover it with community funds or to fine the previous member directly. This goes through the designated process.  If a “direct member” is fined they have a process very similar to the “nomination of removal” process.  If that is resolved, and member does not pay within 1 month their token is automatically sent through the secondary market in order to pay for damages they incurred. Obviously a proposal can be raised to direct funds towards a further lawsuit on behalf of the DAO - or can be pursued privately if damages are significant.
 
## Rental Opportunity:
Although the primary goal of the house is not as a dedicated rental property, it seems prudent to allow for it to gain its highest economic use while not being used.  An online portal that integrates into the designated smart contract would need to be created for a renter to schedule for an unused day as well as pay Eth and submit their address that should be allowed to open doors.
 
## Dependencies:
Need a eth => email or eth => sms notification system.

