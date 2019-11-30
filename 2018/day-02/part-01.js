
const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8').split('\n');;

const counter = (str, count) => {
    // keep track of how many times we touched each character
    const frequency = {};
    for (var i = 0; i < str.length; i++) {
        const char = str.charAt(i).toLowerCase();
        frequency[char] ? frequency[char]++ : frequency[char] = 1;
    }

    return Object.keys(frequency).reduce((accum, char) => frequency[char] === count ? accum = 1 : accum, 0);
};

const numberOfDoubles = input.reduce((runningDoubles, line) => runningDoubles + counter(line, 2), 0);
const numberOfTriples = input.reduce((runningDoubles, line) => runningDoubles + counter(line, 3), 0);
console.log(numberOfDoubles * numberOfTriples);