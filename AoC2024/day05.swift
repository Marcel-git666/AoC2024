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
            input = try readFile("day05.input")
        } catch {
            print("Error reading input file.")
        }
        let parts = input.split(separator: "\n\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        let result = day05Part1(getDictionary(parts[0]), updates: getUpdates(parts[1]))
        print("Part1: \(result)")
        print("Part2: \(day05Part2(getDictionary(parts[0]), updates: getUpdates(parts[1])))")
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
                let relevantDict = dict.filter { key, valueSet in
                    update.contains(key) || !valueSet.intersection(update).isEmpty
                }
                //                print("Processing update: \(update)")
                //                print("Relevant dictionary: \(relevantDict)")
                if !relevantDict.isEmpty {
                    temp = createCorrect(update, dict: relevantDict)
                } else {
                    print("Relevant dictionary is empty, skipping correction for update: \(update)")
                }
                break
            }
        }
        if !isOk {
            if !temp.isEmpty {
                sum += temp[temp.count / 2]
            }
        }
    }
    
    return sum
}

func extractRelevantRules(for update: [Int], from dict: [Int: Set<Int>]) -> [Int: Set<Int>] {
    var relevantRules: [Int: Set<Int>] = [:]
    for page in update {
        if let dependencies = dict[page] {
            relevantRules[page] = dependencies.intersection(Set(update))
        }
    }
    return relevantRules
}

func sortUpdate(_ update: [Int], using rules: [Int: Set<Int>]) -> [Int] {
    return update.sorted { a, b in
        // If `b` depends on `a`, then `a` should come first
        if rules[a]?.contains(b) == true {
            return true
        }
        // If `a` depends on `b`, then `b` should come first
        if rules[b]?.contains(a) == true {
            return false
        }
        // Otherwise, preserve the original order
        return false
    }
}

func createCorrect(_ update: [Int], dict: [Int: Set<Int>]) -> [Int] {
//    print("Original update: \(update)")
    let relevantRules = extractRelevantRules(for: update, from: dict)
//    print("Relevant rules: \(relevantRules)")
    let sortedUpdate = sortUpdate(update, using: relevantRules)
//    print("Sorted update: \(sortedUpdate)")
    return sortedUpdate
}
