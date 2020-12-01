f = open("input.txt", "r")
inputs = f.read().splitlines()

answer = []

def find_values_that_equal(list, value):
    for i in list:
        for j in list:
            if int(i) + int(j) == value:
                return int(i), int(j)

value1, value2 = find_values_that_equal(inputs, 2020)
print(value1 * value2)