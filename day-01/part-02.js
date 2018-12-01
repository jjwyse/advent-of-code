const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8').split('\n');

const previousRunningTotals = {
    0: true
};

let index = 0;
let runningTotal = 0;
while(true) {
    const circularBufferIndex = index % input.length;
    const number = Number(input[index % input.length]);
    runningTotal = runningTotal + number;
    if (previousRunningTotals[runningTotal]) {
        console.log(`BINGO BANGO BONGO: ${runningTotal}`);
        break;
    }
    previousRunningTotals[runningTotal] = true;
    index++;
}