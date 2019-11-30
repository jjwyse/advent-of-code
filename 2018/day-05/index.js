const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8');

const isUpperCase = char => char === char.toUpperCase();
const isLowerCase = char => char === char.toLowerCase();

const findReactors = (str) => {
    for (var i = 1; i < str.length; i++) {
        const prevChar = str.charAt(i - 1);
        const char = str.charAt(i);

        // have a reaction if prevChar is upper, char is lower, and they are the same letter...
        if (isUpperCase(prevChar) && isLowerCase(char) && prevChar.toLowerCase() === char.toLowerCase())  {
            return [i - 1, i];
        }
        // ... or vice versa
        if (isUpperCase(char) && isLowerCase(prevChar) && prevChar.toLowerCase() === char.toLowerCase()) {
            return [i - 1, i];
        }
    }
    return null;
};

const remover = (str) => {
    const reactors = findReactors(str);

    // base case
    if (!reactors) {
        return str;
    }

    // recurse recurse!
    return remover(str.slice(0, reactors[0]) + str.slice(reactors[1] + 1));
};

// part 1
// avoid stack going kaboom
const result1 = remover(input.substring(0, 10000));
const result2 = remover(input.substring(10000, 20000));
const result3 = remover(input.substring(20000, 30000));
const result4 = remover(input.substring(30000, 40000));
const result5 = remover(input.substring(40000, input.length));
const finalResult = remover(result1 + result2 + result3 + result4 + result5);
console.log(finalResult.length);

// part 2
let shortest = Number.MAX_SAFE_INTEGER;
const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
for (var i = 0; i < alphabet.length; i ++) {
    const charToRemove = alphabet[i];
    const regex = new RegExp(charToRemove, "gi");
    const result1 = remover(input.substring(0, 10000).replace(regex, ''));
    const result2 = remover(input.substring(10000, 20000).replace(regex, ''));
    const result3 = remover(input.substring(20000, 30000).replace(regex, ''));
    const result4 = remover(input.substring(30000, 40000).replace(regex, ''));
    const result5 = remover(input.substring(40000, input.length).replace(regex, ''));
    const finalResult = remover(result1 + result2 + result3 + result4 + result5);
    if (finalResult.length < shortest) {
        console.log(`Updating shortest to ${finalResult.length} by removing ${charToRemove}`);
        shortest = finalResult.length;
    }
}
console.log(shortest);
