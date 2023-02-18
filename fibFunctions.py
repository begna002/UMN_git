def fibRecc(num1, num2, count, fibval):
    if (count != 0):
        count -= 1
        num3 = num1 + num2
        fibval.append(num3)
        fib(num2, num3, count, fibval)
    return fibval

def fibIter(num1, num2, count, fibval):
    for i in range(0, count):
        num3 = num1 + num2
        fibval.append(num3)
        num1 = num2
        num2 = num3
    return fibval

def fibCalc(count):
    if (count == 1):
        return [0]
    elif (count == 2):
        return [0, 1]
    else:
        return fib2(0, 1, count - 2, [0, 1])

def leadingOccurences(fibVal):
    fibDic = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0}
    fibDicPercent = {"1": 0.0, "2": 0.0, "3": 0.0, "4": 0.0, "5": 0.0, "6": 0.0, "7": 0.0, "8": 0.0, "9": 0.0}
    total = 0;

    for n in fibVal:
        numStr = str(n)
        firstNum = numStr[:1]
        if firstNum in fibDic:
            fibDic[firstNum] += 1

    for key in fibDic:
        total += fibDic[key]

    for key in fibDicPercent:
        fibDicPercent[key] = (fibDic[key] / total) * 100
    return fibDic, fibDicPercent
