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
            input = try readFile("day07.test")
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

func day07Part1(_ input: [(Int, [Int])]) -> Int {
    print(input)
    
    return -1
}

