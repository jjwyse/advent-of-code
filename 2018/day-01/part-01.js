const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8').split('\n');

const result = input.reduce((runningTotal, number) => runningTotal + Number(number), 0);
console.log(result);