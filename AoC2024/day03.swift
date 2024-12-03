//
//  day03.swift
//  AoC2024
//
//  Created by Marcel Mravec on 03.12.2024.
//

import Foundation

enum Day03 {
    static func run() {
        let input1 = readFile("day03.input")
        
        let result = day03Part1(input1)
        print(result)
//        print(day03Part2(input1))
    }
}

func day03Part1(_ input: String) -> Int {
    let pattern = #"mul\((\d{1,3}),(\d{1,3})\)"#

    var sum = 0

    do {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
        
        for match in matches {
            if let firstNumberRange = Range(match.range(at: 1), in: input),
               let secondNumberRange = Range(match.range(at: 2), in: input) {
                let firstNumber = Int(input[firstNumberRange]) ?? 0
                let secondNumber = Int(input[secondNumberRange]) ?? 0
                sum += firstNumber * secondNumber
            }
        }
        
        print("Sum of products: \(sum)")
        return sum
    } catch {
        print("Invalid regex: \(error.localizedDescription)")
    }
    return 0
}
