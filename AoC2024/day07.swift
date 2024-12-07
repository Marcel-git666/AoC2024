//
//  day07.swift
//  AoC2024
//
//  Created by Marcel Mravec on 07.12.2024.
//

import Foundation

enum Day07 {
    static func run() {
        var input: String = ""
        do {
            input = try readFile("day07.input")
        } catch {
            print("Error reading input file.")
        }
        let result = day07Part1(getArray(input))
        print(result)
//        print(day07Part2(getMap(input)))
    }
}

func getArray(_ input: String) -> [(Int, [Int])] {
    input.split(separator: "\n").map { line in
        let parts = line.split(separator: ":")
        let target = (Int(parts[0]) ?? -1)
        return (target, parts[1].split(separator: " ").compactMap { Int($0) })
    }
}

func generateOperators(_ count: Int) -> [[String]] {
    let totalCombinations = Int(pow(2.0, Double(count)))
    var combinations = [[String]]()
    
    for i in 0..<totalCombinations {
        var operators = [String]()
        for bit in 0..<count {
            // Check if the bit at position `bit` is 0 or 1
            let isMultiply = (i & (1 << bit)) != 0
            operators.append(isMultiply ? "*" : "+")
        }
        combinations.append(operators)
    }
    
    return combinations
}

func test(target: Int, numbers: [Int], operators: [[String]]) -> Int {
    
    for operatorLine in operators {
        var test = numbers[0]
        for i in 1..<numbers.count {
            switch operatorLine[i - 1] {
            case "+": test += numbers[i]
            case "*": test *= numbers[i]
            default: break
            }
        }
        if test == target {
            return target
        }
    }
    return 0
}

func day07Part1(_ input: [(Int, [Int])]) -> Int {
    print(input)
    var calibrationResult = 0
    for line in input {
        let operatorCombinations = generateOperators(line.1.count - 1)
        calibrationResult += test(target: line.0, numbers: line.1, operators: operatorCombinations)
    }
    return calibrationResult
}

