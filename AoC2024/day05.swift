//
//  day05.swift
//  AoC2024
//
//  Created by Marcel Mravec on 05.12.2024.
//

import Foundation

enum Day05 {
    static func run() {
        var input: String = ""
        do {
            input = try readFile("day05.test")
        } catch {
            print("Error reading input file.")
        }
        let parts = input.split(separator: "\n\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        let result = day05Part1(getDictionary(parts[0]), updates: getUpdates(parts[1]))
        print(result)
        print(day05Part2(getDictionary(parts[0]), updates: getUpdates(parts[1])))
    }
}

func getDictionary(_ input: String) -> [Int: Set<Int>] {
    var dict: [Int: Set<Int>] = [:]
    for ordering in input.split(separator: "\n") {
        let line = ordering.split(separator: "|").compactMap { Int($0) }
        if dict[line[0]] != nil {
            dict[line[0]]!.formUnion(line[1...])
        } else {
            dict[line[0]] = Set(line[1...])
        }
    }
    return dict
}

func getUpdates(_ input: String) -> [[Int]] {
    input.split(separator: "\n").map { line in
        line.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").compactMap { Int($0) }
    }
}

func day05Part1(_ dict: [Int: Set<Int>], updates: [[Int]]) -> Int {
    var sum = 0
    var isOk = true
    updates.forEach { update in
        for i in 0..<update.count - 1 {
            if dict[update[i]]?.contains(update[i+1]) ?? false {
                isOk = true
            }
            else {
                isOk = false
                break
            }
        }
        if isOk {
            // print(update[update.count/2])
            sum += update[update.count/2]
        }
    }
    
    return sum
}

func day05Part2(_ dict: [Int: Set<Int>], updates: [[Int]]) -> Int {
    var sum = 0
    var isOk = true
    var temp = [Int]()
    updates.forEach { update in
        for i in 0..<update.count - 1 {
            if dict[update[i]]?.contains(update[i+1]) ?? false {
                isOk = true
            }
            else {
                isOk = false
                temp = createCorrect(update, dict: dict)
                break
            }
        }
        if !isOk {
            print(temp[temp.count/2])
            sum += temp[temp.count/2]
        }
    }
    
    return sum
}

func createCorrect(_ update: [Int], dict: [Int: Set<Int>]) -> [Int] {
    var result: [Int] = update
    for i in 1..<result.count - 1 {
        if dict[result[i-1]]?.contains(result[i]) == nil {
            let temp = result[i-1]
            result[i-1] = result[i]
            result[i] = temp
        }
    }
    
    return result
}
