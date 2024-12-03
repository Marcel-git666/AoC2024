//
//  day03.swift
//  AoC2024
//
//  Created by Marcel Mravec on 03.12.2024.
//

import Foundation

enum Day03 {
    static func run() {
        var input1: String = ""
        do {
            input1 = try readFile("day03.input")
        } catch {
            print("Error reading input file.")
        }
        let result = day03Part1(input1)
        print(result)
        print(day03Part2(input1))
    }
}

func day03Part1(_ input: String) -> Int {
    let pattern = /mul\((?<first>\d{1,3}),(?<second>\d{1,3})\)/
    
    var sum = 0
    
    for match in input.matches(of: pattern) {
        if let firstNumber = Int(match.first), let secondNumber = Int(match.second) {
            sum += firstNumber * secondNumber
        }
    }
    
    print("Sum of products: \(sum)")
    return sum
}

func day03Part2(_ input: String) -> Int {
    let pattern = /do\(\)|don\'t\(\)|mul\((?<first>\d{1,3}),(?<second>\d{1,3})\)/
    
    var sum = 0
    var canMultiply = true
    for match in input.matches(of: pattern) {
        let string = match.0
        if string == "do()" {
            canMultiply = true
        } else if string == "don't()" {
            canMultiply = false
        } else if canMultiply, let first = match.first, let second = match.second {
            let firstNumber = Int(first) ?? 0
            let secondNumber = Int(second) ?? 0
            sum += firstNumber * secondNumber
        }
    }
    print("Sum of products: \(sum)")
    return sum
}

//var shouldMultiply = true
