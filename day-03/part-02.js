const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8').split('\n');;

const claims = [];
const rows = 1000;
const columns = 1000;
for (var i = 0; i < rows; i++) {
    claims[i] = [];
    for (var j = 0; j < columns; j++) {
        claims[i].push(0);
    }
}

input.forEach(line => {
    // :see_no_evil:
    const lineSplit = line.split(' ');
    const x = Number(lineSplit[2].split(',')[0])
    const y = Number(lineSplit[2].split(',')[1].slice(0, -1))

    const xWidth = Number(lineSplit[3].split('x')[0]);
    const yWidth = Number(lineSplit[3].split('x')[1]);
    for (var i = y; i < y + yWidth; i++) {
        for (var j = x; j < x + xWidth; j++) {
            claims[i][j]++;
        }
    }
});

// go through each input line and see if it's still intact, by looking for "1"s in all [column][row]
const winning = input.reduce((winningLine, line) => {
    const lineSplit = line.split(' ');
    const x = Number(lineSplit[2].split(',')[0])
    const y = Number(lineSplit[2].split(',')[1].slice(0, -1))

    const xWidth = Number(lineSplit[3].split('x')[0]);
    const yWidth = Number(lineSplit[3].split('x')[1]);
    for (var i = y; i < y + yWidth; i++) {
        for (var j = x; j < x + xWidth; j++) {
            if (claims[i][j] > 1) {
                return winningLine;
            }
        }
    }
    winningLine = line;
    return winningLine;
}, '');
console.log(winning);