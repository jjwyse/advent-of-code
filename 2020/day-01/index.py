f = open("input.txt", "r")
inputs = f.read().splitlines()

answer = []

def find_values_that_equal(list, value):
    for i in list:
        for j in list:
            for k in list:
                if int(i) + int(j) + int(k) == value:
                    return int(i), int(j), int(k)

value1, value2, value3 = find_values_that_equal(inputs, 2020)
print(value1 * value2 * value3)