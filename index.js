var express = require('express')
var app = express()
var bodyParser = require('body-parser');

var HDWalletProvider = require("truffle-hdwallet-provider");
var constants = require("./constants");

var fs = require('fs');
var Web3 = require('web3');
var provider = new Web3.providers.HttpProvider("http://localhost:8545/");
// var provider = new HDWalletProvider(constants.mnemonic, "https://ropsten.infura.io/" + constants.infura_apikey);
var web3 = new Web3(provider);
var contract = require('truffle-contract');

var Hub, Proposal;
var hubInstance;
var account;

var twilio = require('twilio')(constants.twilioAccountNumber, constants.twilioAuthToken);
var fromNumberProposal = constants.twilioFromNumberProposal;
var fromNumberRegistration = constants.twilioFromNumberRegistration;
var testPhoneNumber = constants.testPhoneNumber

fs.readFile('build/contracts/Hub.json', (error, json) => {
    var json = JSON.parse(json);
    Hub = contract(json);
    Hub.setProvider(web3.currentProvider);
});

fs.readFile('build/contracts/ResourceProposal.json', (error, json) => {
    var json = JSON.parse(json);
    ResourceProposal = contract(json);
    ResourceProposal.setProvider(web3.currentProvider);
});

web3.eth.getAccounts(function(err, accs) {
    if (err != null) {
      alert("There was an error fetching your accounts.");
      return;
    }
    if (accs.length == 0) {
      alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
      return;
    }

    accounts = accs;
    account = accounts[0];
    
    Hub.deployed().then(function(instance){
        hubInstance = instance;
        watchProposals();        
    });
});

var watchProposals = function(){
    const proposalEvent = hubInstance.LogNewProposal({},{fromBlock: 'latest'});
    proposalEvent.watch(function(error, result){
        hubInstance.memberDetails(result.args.chairmanAddress, {from:account}).then(function(details){
            const user = details[1];
            const message = formatMessage(result.args.text, result.args.pid, user, result.args.cost, result.args.fees);
            sendMessages(message)
        });            
    });
    const nRProposoalEvent = hubInstance.LogNewNRProposal({}, {fromBlock: 'latest'});
    nRProposoalEvent.watch(function(error,result){
        const message = formatMessage(result.ars.text, result.args.pid);
        sendMessages(message);
    });
    console.log('watching');
}

var formatMessage = function(text, proposalId, user, cost, fees){
    var message = "";
    if(user){
        message += user + " proposes: ";
    }else{
        message += "New proposal: ";
    }
    message += "\"" + text + "\" ";
    if(cost && fees){
        const totalCost = web3.fromWei(parseInt(cost) + parseInt(fees), 'ether');
        message += " The proposal will cost " + totalCost + "ETH.";    
    }else{
        message += " This is a non-resource proposal."
    }
    message += " Respond with \"Y" + proposalId + "\" to vote yes, \"N" + proposalId + "\" to vote no, or \"A" + proposalId + "\" to abstain.";
    return message;
}

var sendMessages = function(message){
    hubInstance.getMembers({from:account}).then(function(members){
        for(let i=0; i<members.length; i++){
            console.log(members[i])
            hubInstance.memberDetails(members[i], {from:account}).then(function(details){
                const number = details[0];
                if(number.length > 0){
                    sendMessage(number, message);
                }                
            })
        }
    })      
}

var sendMessage = function(number, message){
    console.log('Sending message to: ', number);
    twilio.messages.create({
        to: "+"+number,
        from: fromNumberProposal,
        body: message,
    }, function(err, message) {
        console.log(err)
        console.log(message);
    });
}

var castVote = function(proposalId, number, vote){
    const proposalEvent = hubInstance.LogNewProposal({pid:proposalId},{fromBlock: 0, toBlock: 'latest'});
    proposalEvent.watch(function(error, result){
        const propAddress = result.args.proposalAddress;
        const registerEvent = hubInstance.LogMemberRegistered({phoneNumber:number},{fromBlock: 0, toBlock: 'latest'});
        registerEvent.watch(function(error, result){
            const memberAddress = result.args.member;            
            ResourceProposal.at(propAddress).then(function(instance){
                instance.castVoteByText(vote, memberAddress, {from:account}).then(function(tx){
                    console.log(tx);
                })
                .catch(function(err){
                    sendMessage(number, "Something went wrong while casting your vote on proposal " + proposalId + ".");
                });
            })
        })
    });

    const nRProposalEvent = hubInstance.LogNewNRProposal({pid:proposalId},{fromBlock: 0, toBlock: 'latest'});
    nRProposalEvent.watch(function(error, result){
        const propAddress = result.args.proposalAddress;
        const registerEvent = hubInstance.LogMemberRegistered({phoneNumber:number},{fromBlock: 0, toBlock: 'latest'});
        registerEvent.watch(function(error, result){
            const memberAddress = result.args.member;            
            NonResourceProposal.at(propAddress).then(function(instance){
                instance.castVoteByText(vote, memberAddress, {from:account}).then(function(tx){
                    console.log(tx);
                })
                .catch(function(err){
                    sendMessage(number, "Something went wrong while casting your vote on proposal " + proposalId + ".");
                });
            })
        })
    });
}


var sendRegistration = function(code, number){
    const messageText = "Your verification Code is " + code;
    twilio.messages.create({
        to: "+"+ number,
        from: fromNumberRegistration,
        body: messageText,
    }, function(err, message) {
        console.log(err)
        console.log(message);
    });
 }

app.set('port', (process.env.PORT || 5000))
app.use(express.static(__dirname + '/public'))
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));

app.post('/register', (req, res) => {
    messageCode =  Math.floor(100000 + Math.random() * 900000);
    console.log(req.body.number);
    sendRegistration(messageCode,req.body.number);
    res.send(""+ messageCode);
})

app.post('/vote', (req, res) => {
    const MessagingResponse = require('twilio').twiml.MessagingResponse;
    const response = req.body.Body;
    const number = req.body.From.substring(1, req.body.From.length);
    const rawVote = response[0];
    const proposal = parseInt(response.substring(1,response.length));
    let vote = -1;
    if(rawVote == 'a' || rawVote == 'A') vote = 0;
    if(rawVote == 'y' || rawVote == 'Y') vote = 1;
    if(rawVote == 'n' || rawVote == 'N') vote = 2;
    let message;

    if(isNaN(proposal)){
        message = "Invalid response. Please respond with a proposal number."
    }else if(vote == -1){
        message = "Invalid response. Please respond with A, Y, or N."
    }else{
        if(vote == 0){
            message = "You abstained on proposal " + proposal + ".";
        }else if(vote == 1){
            message = "You voted yes on proposal " + proposal + ".";
        }else{
            message = "You voted no on proposal " + proposal + ".";
        }
        castVote(proposal, number, vote);
    }

    const twiml = new MessagingResponse();
    twiml.message(message);
    res.writeHead(200, {'Content-Type': 'text/xml'});
    res.end(twiml.toString());
});

// app.get('/', function(request, response) {
//     console.log('creating proposal')
//     hubInstance.createResourceProposal("0xE0432C23Eb6d243413A88DdC71eB8B8af9b87c53", 500000000000000000, 10, 73000000000000000, "We should buy our own espresso machine.", {from:account, gas: 1000000})
//     .then(function(tx){
//         console.log("proposal created");
//     })
//     response.send('Hello World!')
// })

// app.get('/register', function(req, res){
//     console.log('registering');
//     hubInstance.register(constants.testPhoneNumber, "Daniel", {from:account, value: 100, gas: 300000}).then(function(tx){
//         console.log(tx);
//     });
//     res.send('Registration');
// })

app.listen(app.get('port'), function() {
    console.log("Node app is running at localhost:" + app.get('port'))
})