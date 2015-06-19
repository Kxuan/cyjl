#!/usr/bin/js
// vim: ts=4 filetype=javascript
var goal = '称';
var cy = require('./data.js');
var fs = require('fs');
var readline = require('readline');
var rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout
});
var endbyc = [];
function last(str) {return str[str.length-1];}
function first(str) {return str[0];}
function fstart(word,cy) {
	var ret = [];
	for(var i=0;i<cy.length;i++)
		if(first(cy[i]) == word)
			ret.push(cy[i]);
	return ret;
}
function fend(word,cy) {
	var ret = [];
	for(var i=0;i<cy.length;i++)
		if(last(cy[i]) == word)
			ret.push(cy[i]);
	return ret;
}
function flink(start,end,dict) {
	var ret = [];
	for(var i=0;i<dict.length;i++)
		if(first(dict[i]) == start && last(dict[i]) == end) 
			ret.push(dict[i]);
	return ret;
}
function fmatch(cy,dict) {
	for(var i=0;i<dict.length;i++)
		if (dict[i] == cy) 
			return true;
	return false;
}
function find(sw) {
	var i,j,k;
	var cystep1 = fstart(sw, cy);
	var cydirect;
	if (cystep1.length == 0) {
		console.log("没找到“" + sw + "”开头的成语");
	}
	cydirect = fend(goal, cystep1);
	if (cydirect.length != 0) {
		for(i=0;i<cydirect.length;i++)
			console.log(cydirect[i]);
		return;
	}
	var cystep2 = [];
	var cytl;
	for(i = 0; i < cystep1.length; i++) {
		for (j = 0; j < endbyc.length; j++) {
			cytl = flink(last(cystep1[i]), first(endbyc[j]), cy);
			if (cytl.length != 0) {
				cystep2.push({s: cystep1[i], e: endbyc[j], l: cytl, p:fstart(first(endbyc[j]),cy).length});
			}
		}
	}
	if (cystep2.length == 0) {
		console.log("没找到。尝试：");
		console.log(cystep1);
	} else {
		console.log(cystep2);
	}
}
function writecy() {
	fs.writeFileSync("data.js","module.exports=[\"" + cy.join("\",\"") +"\"];");
}
function doprompt(word) {
	if (word.length==4&&!fmatch(word,cy)) {
		cy.push(word);
		writecy();
	}
	find(last(word));
	rl.question(":", doprompt);
}
endbyc = fend(goal, cy);
console.log(endbyc);
rl.question(":", doprompt);
