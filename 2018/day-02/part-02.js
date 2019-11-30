
const fs = require('fs')
const input = fs.readFileSync('./input.txt', 'utf8').split('\n');;

const differBy = (str1, str2, differBy) => {
    let diffCounter = 0;
    for (var i = 0; i < str1.length; i++) {
        if (str1.charAt(i) !== str2.charAt(i)) {
            diffCounter++;
        }
    }
    return diffCounter === differBy;
};

for (var i = 0; i < input.length; i++) {
    const line1 = input[i];
    for (var j = 0; j < input.length; j++) {
        // don't care to myself
        if (i == j) continue;

        const line2 = input[j];
        if (line1 === line2) continue;
        if (line1.length !== line2.length) continue;
        if (differBy(line1, line2, 1)) {
            console.log(line1);
            console.log(line2);
            process.exit(0);
        }
    }
}