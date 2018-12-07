
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

const findNextStep = (steps, runSteps) => {
    // we've run them all
    if (Object.keys(steps).length === runSteps.length) {
        return null;
    }

    const possibleNextSteps = Object.keys(steps)
        .filter(stepName => !runSteps.includes(stepName))
        .reduce((nextSteps, stepName) => {
            const step = steps[stepName];
            if (step.dependencies.length <= 0 || step.dependencies.every(dep => runSteps.includes(dep))) {
                nextSteps.push(stepName);
            }
            return nextSteps.sort();
        }, []);
    return possibleNextSteps[0];
}

const runInstructions = (steps, runSteps = []) => {
    const nextStep = findNextStep(steps, runSteps);
    if (!nextStep) {
        return runSteps;
    }
    runSteps.push(nextStep);
    return runInstructions(steps, runSteps);
};

const instructions = runInstructions(allSteps);
instructions.forEach(stepName => process.stdout.write(stepName));
console.log();