//
//  day11.swift
//  AoC2024
//
//  Created by Marcel Mravec on 11.12.2024.
//

import Foundation

class Day11 {
    @MainActor private static var cache = [String: Int]() // Shared cache for memoization

    @MainActor static func run() {
        var input: String = ""
        
        print("Let the war begin!")
        do {
            input = try readFile("day11.input")
            print("File loaded: \(input)")
        } catch {
            print("Error reading input file.")
        }

        // Part 1
        let part1Result = day11Part1(getIntArray(input))
        print("Part 1 Result: \(part1Result)")

        // Part 2
        let part2Result = part2(getIntArray(input))
        print("Part 2 Result: \(part2Result)")
    }

    static func getIntArray(_ input: String) -> [Int] {
        input.trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .map { Int(String($0)) ?? -1 }
    }

    static func day11Part1(_ input: [Int]) -> Int {
        var array = input
        for counter in 1...25 {
            if counter % 5 == 0 {
                print("Counter: \(counter), array count: \(array.count)")
            }
            var i = 0
            while i < array.count {
                switch array[i] {
                case 0:
                    array[i] = 1
                case let value where (Int(log10(Double(value))) + 1) % 2 == 0:
                    let digitCount = Int(log10(Double(array[i]))) + 1
                    let divisor = Int(pow(10.0, Double(digitCount / 2)))
                    let leftHalf = array[i] / divisor
                    let rightHalf = array[i] % divisor
                    array[i] = rightHalf
                    array.insert(leftHalf, at: i)
                    i += 1
                default:
                    array[i] *= 2024
                }
                i += 1
            }
        }
        return array.count
    }

    @MainActor static func apply(_ stone: Int, count: Int) -> Int {
        // Base case: no iterations left
        if count == 0 {
            return 1
        }

        // Check the cache
        let key = "\(stone)-\(count)"
        if let cachedResult = cache[key] {
            return cachedResult
        }

        // Recursive cases
        let result: Int
        if stone == 0 {
            result = apply(1, count: count - 1)
        } else {
            let digits = Int(log10(Double(stone))) + 1
            if digits % 2 == 0 {
                let pow10 = Int(pow(10.0, Double(digits / 2)))
                let leftHalf = stone / pow10
                let rightHalf = stone % pow10
                result = apply(leftHalf, count: count - 1) + apply(rightHalf, count: count - 1)
            } else {
                result = apply(stone * 2024, count: count - 1)
            }
        }

        // Store result in cache
        cache[key] = result
        return result
    }

    @MainActor static func part2(_ stones: [Int]) -> Int {
        // Process each stone in the array
        stones.reduce(0) { $0 + apply($1, count: 75) }
    }
}
