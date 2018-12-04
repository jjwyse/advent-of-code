const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8').split('\n');;

/* Helper */
const prettyPrint = a => {
    for (i = 0; i < a.length; i++) {
        console.log();
        for (j = 0; j < a[i].length; j++) {
            process.stdout.write(`${a[i][j]} `);
        }
    }
    console.log();
}

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

const numberRepeated = claims.reduce((counter, claim) => {
    claim.forEach(c => {
        if (c > 1) counter++;
    });
    return counter;
}, 0);
console.log(numberRepeated);
