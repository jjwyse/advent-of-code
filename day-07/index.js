const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8').split('\n');

const allSteps = input.reduce((steps, line) => {
    // TODO - learn how to use a regex here :see_no_evil: ...
    const step = line.split(' ')[7];
    const dependentStep = line.split(' ')[1];

    // initialize
    if (!steps[step]) {
        steps[step] = { dependencies: [] };
    }
    if (!steps[dependentStep]) {
        steps[dependentStep] = { dependencies: [] };
    }

    // add dependent step to step
    steps[step].dependencies.push(dependentStep);
    return steps;
}, {});

const findNextSteps = (steps, runSteps) => {
    // we've run them all
    if (Object.keys(steps).length === runSteps.length) {
        return [];
    }

    return Object.keys(steps)
        .filter(stepName => !runSteps.includes(stepName))
        .reduce((nextSteps, stepName) => {
            const step = steps[stepName];
            if (step.dependencies.length <= 0 || step.dependencies.every(dep => runSteps.includes(dep))) {
                nextSteps.push(stepName);
            }
            return nextSteps.sort();
        }, []);
}

const runInstructions = (steps, runSteps = []) => {
    const nextSteps = findNextSteps(steps, runSteps);
    if (nextSteps.length <= 0) {
        return runSteps;
    }
    runSteps.push(nextSteps[0]);
    return runInstructions(steps, runSteps);
};

// part 1
const instructions = runInstructions(allSteps);
instructions.forEach(stepName => process.stdout.write(stepName));
console.log();

// part 2
const numberOfWorkers = 5;
const baseCost = 60; // seconds
const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const calculateCost = letter => alphabet.indexOf(letter.toUpperCase()) + 1 + baseCost;

const runInstructionsInParallel = (steps, runSteps, runningSteps, second) => {
    const nextSteps = findNextSteps(steps, runSteps);
    if (nextSteps.length <= 0) {
        return second;
    }

    // see which steps are done at our next second
    const nowRunningSteps = runningSteps
        .filter(s => s.doneAtSecond > second + 1);
    const nowRunSteps = runSteps
        .concat(runningSteps
            .filter(s => s.doneAtSecond <= second + 1)
            .map(s => s.name));

    // see if we can start running any new step
    nextSteps
        .forEach(nextStep => {
            if (nowRunningSteps.length < numberOfWorkers) {
                const cost = calculateCost(nextStep);
                if (!runningSteps.some(s => s.name === nextStep)) {
                    nowRunningSteps.push({ name: nextStep, doneAtSecond: second + cost });
                }
            }
        });

    return runInstructionsInParallel(steps, nowRunSteps, nowRunningSteps, second + 1)
};
const instructionsInParallel = runInstructionsInParallel(allSteps, [], [], 0);
console.log(instructionsInParallel);