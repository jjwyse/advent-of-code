const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8').split('\n');;

const result = numbers.reduce((runningTotal, number) => runningTotal + Number(number), 0);
console.log(result);