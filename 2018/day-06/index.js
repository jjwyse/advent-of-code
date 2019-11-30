const fs = require('fs')
const input = fs.readFileSync('./test-input.txt', 'utf8').split('\n');
const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

const prettyPrint = a => {
    for (i = 0; i < a.length; i++) {
        console.log();
        for (j = 0; j < a[i].length; j++) {
            process.stdout.write(`${a[i][j]} `);
        }
    }
    console.log();
}

const buildMap = (rows, columns) => {
    const map = [];
    for (var i = 0; i < rows; i++) {
        map[i] = [];
        for (var j = 0; j < columns; j++) {
            map[i].push('.');
        }
    }
    return map;
};

const map = input.reduce((map, coordinate, index) => {
    const name = alphabet[index];
    const y = Number(coordinate.split(',')[0]);
    const x = Number(coordinate.split(',')[1]);
    map[x][y] = name;
    return map;
}, buildMap(10, 10));

prettyPrint(map);