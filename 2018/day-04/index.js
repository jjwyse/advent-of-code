const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8').split('\n');

const sortedInput = input.sort()

/*
{
  "#10": {
    "shiftStart": [],
    "asleep": [],
    "awake": []
  }
}
*/
const guards = {};
let currentGuardIdOnShift = null;
sortedInput.forEach(line => {
    const date = line.split(']')[0].trim();
    const action = line.split(']')[1].trim();
    if (action.startsWith('Guard')) {
        const guardId = action.split(' ')[1];
        if (!guards[guardId]) {
            guards[guardId] = {
                asleep: [],
                awake: [],
                sleepingTime: 0,
                minutesAsleep: []
            };
        }
        currentGuardIdOnShift = guardId;
    } else if (action.startsWith('falls')) {
        guards[currentGuardIdOnShift].asleep.push(Number(date.split(':')[1]));
    } else if (action.startsWith('wakes')) {
        guards[currentGuardIdOnShift].awake.push(Number(date.split(':')[1]));
    }
});

// mutating guards more
Object.keys(guards).forEach(guardId => {
    const asleep = guards[guardId].asleep;
    const awake = guards[guardId].awake;
    asleep.forEach((asleepDate, index) => {
        // hide yo kids ...
        const awakeDate = awake[index];
        const duration = awakeDate - asleepDate;
        guards[guardId].sleepingTime += duration
        for (var i = asleepDate; i < awakeDate; i++) {
            guards[guardId].minutesAsleep.push(i);
        }
    });
});

/* 
mainly hijacked from https://jonlabelle.com/snippets/view/javascript/calculate-mean-median-mode-and-range-in-javascript, and slightly
modified to return [mode, occurences] instead of [modes]
*/
const mode = (numbers) => {
    // as result can be bimodal or multi-modal,
    // the returned result is provided as an array
    // mode of [3, 5, 4, 4, 1, 1, 2, 3] = [1, 3, 4]
    var modes = [], count = [], i, number, maxIndex = 0;
 
    for (i = 0; i < numbers.length; i += 1) {
        number = numbers[i];
        count[number] = (count[number] || 0) + 1;
        if (count[number] > maxIndex) {
            maxIndex = count[number];
        }
    }
 
    for (i in count)
        if (count.hasOwnProperty(i)) {
            if (count[i] === maxIndex) {
                modes.push(Number(i));
            }
        }
 
    return [modes[0], maxIndex];
};

const guardAsleepMost = Object.keys(guards).reduce((winningGuard, guardId) => {
    if (guards[guardId].sleepingTime > winningGuard.sleepingTime) {
        return winningGuard = Object.assign({}, {id: guardId}, guards[guardId]);
    }
    return winningGuard;
}, { sleepingTime: -1 });

// part 1
const guardIdAsleepMost = Number(guardAsleepMost.id.substring(1));
const mostCommonMinute = mode(guardAsleepMost.minutesAsleep);
console.log(guardIdAsleepMost * mostCommonMinute[0]);

// part 2
console.log(guards);
const guardAsleepAtSameTimeMost = Object.keys(guards).reduce((winningGuard, guardId) => {
    const guard = guards[guardId];
    const mostCommonMinute = mode(guard.minutesAsleep);
    const minute = mostCommonMinute[0];
    const occurences = mostCommonMinute[1];
    if (occurences > winningGuard.occurences) {
        winningGuard = Object.assign({}, {id: guardId, occurences: occurences, minute: minute});
    }
    return winningGuard;
}, {occurences: -1, minute: -1});

const id = Number(guardAsleepAtSameTimeMost.id.substring(1));
console.log(id);
const minute = guardAsleepAtSameTimeMost.minute;
console.log(minute);
console.log(id * minute);